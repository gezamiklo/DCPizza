//
//  RepositoryUseCaseProvider.swift
//  Domain
//
//  Created by Balázs Kilvády on 2/18/20.
//  Copyright © 2020 kil-dev. All rights reserved.
//

import Foundation

public struct RepositoryUseCaseProvider: UseCaseProvider, DatabaseContainerProtocol {
    var container: DS.Container?
    private let _data: Initializer

    public init() {
        container = RepositoryUseCaseProvider.initContainer()
        _data = Initializer(container: container, network: API.Network())
    }

    init(container: DS.Container? = nil, network: NetworkProtocol) {
        if let container = container {
            self.container = container
        } else {
            self.container = RepositoryUseCaseProvider.initContainer()
        }
        _data = Initializer(container: container, network: network)
    }

    public func makeNetworkUseCase() -> NetworkUseCase {
        RepositoryNetworkUseCase(container: container)
    }

    public func makeMenuUseCase() -> MenuUseCase {
        MenuRepository(data: _data)
    }

    public func makeIngredientsService() -> IngredientsUseCase {
        IngredientsRepository(data: _data)
    }
}
