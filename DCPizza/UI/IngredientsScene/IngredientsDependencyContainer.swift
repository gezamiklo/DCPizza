//
//  IngredientsDependencyContainer.swift
//  DCPizza
//
//  Created by Balázs Kilvády on 5/17/20.
//  Copyright © 2020 kil-dev. All rights reserved.
//

import Foundation
import Combine
import Domain

class IngredientsDependencyContainer {
    let provider: UseCaseProvider
    let service: IngredientsUseCase

    public init(appDependencyContainer: AppDependencyContainer, pizza: AnyPublisher<Pizza, Never>) {
        provider = appDependencyContainer.provider
        service = provider.makeIngredientsService(pizza: pizza)
    }

    func makeIngredientsViewModel() -> IngredientsViewModel {
        IngredientsViewModel(service: service)
    }
}
