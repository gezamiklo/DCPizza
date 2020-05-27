//
//  Initializer.swift
//  Domain
//
//  Created by Balázs Kilvády on 5/12/20.
//

import Foundation
import class AlamofireImage.Image
import Combine

final class Initializer {
    struct Components {
        let pizzas: Pizzas
        let ingredients: [Ingredient]
        let drinks: [Drink]

        static let empty = Components(pizzas: Pizzas(pizzas: [], basePrice: 0), ingredients: [], drinks: [])
    }

    typealias ComponentsResult = Result<Components, API.ErrorType>

    let container: DS.Container?
    let network: NetworkProtocol

    @Published var cart = Cart.empty
    @Published var component: ComponentsResult = .failure(API.ErrorType.disabled)

    private var _bag = Set<AnyCancellable>()

    init(container: DS.Container?, network: NetworkProtocol) {
        self.container = container
        self.network = network

        _bag = [
            // Get components.
            Publishers.Zip3(network.getPizzas(),
                            network.getIngredients(),
                            network.getDrinks())
                .map({ (tuple: (pizzas: DS.Pizzas, ingredients: [DS.Ingredient], drinks: [DS.Drink])) -> ComponentsResult in
                    let ingredients = tuple.ingredients.sorted { $0.name < $1.name }

                    let components = Components(pizzas: tuple.pizzas.asDomain(with: ingredients, drinks: tuple.drinks),
                                                ingredients: ingredients,
                                                drinks: tuple.drinks)
                    return .success(components)
                })
                .catch({
                    Just(ComponentsResult.failure($0))
                })
                .assign(to: \.component, on: self),

            // Download pizza images.
            $component
                .compactMap({ try? $0.get() })
                .sink(receiveValue: { components in
                    components.pizzas.pizzas.forEach { pizza in
                        guard let imageUrl = pizza.imageUrl else { return }
                        let downloader = API.ImageDownloader(path: imageUrl.absoluteString)
                        downloader.cmb.perform()
                            .map({ $0 as Image? })
                            .catch({ error -> Just<Image?> in
                                DLog("Error during image receiving: ", error)
                                return Just<Image?>(nil)
                            })
//                            .handleEvents(receiveOutput: {
//                                DLog("Inserting ", $0 == nil ? "nil" : "not nil")
//                            })
                            .subscribe(AnySubscriber(pizza.image_))
                    }
                }),

            // Init card.
            $component
                .subscribe(on: DispatchQueue.global(qos: .default))
                .map({ [weak container] comp -> Cart in
                    guard case let ComponentsResult.success(c) = comp else { return Cart.empty }

                    let dsCart = container?.values(DS.Cart.self).first ?? DS.Cart(pizzas: [], drinks: [])
                    var cart = dsCart.asDomain(with: c.ingredients, drinks: c.drinks)
                    cart.basePrice = c.pizzas.basePrice
                    return cart
                })
                .receive(on: RunLoop.main)
                .assign(to: \.cart, on: self),
        ]
    }
}
