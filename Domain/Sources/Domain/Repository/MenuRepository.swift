//
//  MenuRepository.swift
//
//
//  Created by Balázs Kilvády on 5/14/20.
//

import Foundation
import Combine

struct MenuRepository: MenuUseCase {
    private let _data: Initializer

    init(data: Initializer) {
        _data = data
    }

    func pizzas() -> AnyPublisher<PizzasResult, Never> {
        _data.$component
            .map({
                $0.flatMap { components in
                    PizzasResult.success(components.pizzas)
                }
            })
            .eraseToAnyPublisher()
    }

    func addPizza(pizza: Pizza) -> AnyPublisher<Void, Error> {
        Publishers.CartActionPublisher(data: _data, action: .pizza(pizza: pizza)).eraseToAnyPublisher()
    }

    func saveCart() -> AnyPublisher<Void, Error> {
        Publishers.CartActionPublisher(data: _data, action: .save).eraseToAnyPublisher()
    }
}