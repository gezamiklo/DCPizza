//
//  MenuCellViewModel.swift
//  DCPizza
//
//  Created by Balázs Kilvády on 2/18/20.
//  Copyright © 2020 kil-dev. All rights reserved.
//

import Foundation
import Domain
import class UIKit.UIImage
import Combine

struct MenuCellViewModel {
    let nameText: String
    let ingredientsText: String
    let priceText: String
    let image: AnyPublisher<UIImage?, Never>
    let tap = PassthroughSubject<Void, Never>()

    init(basePrice: Double, pizza: Pizza) {
        nameText = pizza.name
        let price = pizza.price(from: basePrice)
        priceText = format(price: price)
        ingredientsText = pizza.ingredientNames()
        image = pizza.image
    }
}

extension MenuCellViewModel: Hashable {
    static func ==(lhs: MenuCellViewModel, rhs: MenuCellViewModel) -> Bool {
        lhs.nameText == rhs.nameText
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(nameText.hash)
    }
}
