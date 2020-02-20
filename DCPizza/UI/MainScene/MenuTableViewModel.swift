//
//  MenuTableViewModel.swift
//  DCPizza
//
//  Created by Balázs Kilvády on 2/18/20.
//  Copyright © 2020 kil-dev. All rights reserved.
//

import Foundation
import Domain
import RxSwift
import RxDataSources
import struct RxCocoa.Driver
import class UIKit.UIImage

struct MenuTableViewModel: ViewModelType {
    typealias Selected = (index: Int, image: UIImage?)
    typealias Selection = (pizza: Pizza, image: UIImage?, ingredients: [Ingredient])

    struct Input {
        let selected: Observable<Selected>
    }

    struct Output {
        let tableData: Driver<[SectionModel]>
        let selection: Driver<Selection>
    }

    func transform(input: Input) -> Output {
        let useCase = RepositoryNetworkUseCaseProvider().makeNetworkUseCase()
        let data = useCase.getInitData().share()

        let sections = data
            .map({ data -> [SectionModel] in
                let basePrice = data.pizzas.basePrice
                let vms = data.pizzas.pizzas.map {
                    MenuCellViewModel(basePrice: basePrice, pizza: $0)
                }
                return [SectionModel(items: vms)]
            })
            .asDriver(onErrorJustReturn: [])

        let selection = input.selected
            .withLatestFrom(data) { (data: $1, selected: $0) }
            .map({ t -> Selection in
                let pizza = t.data.pizzas.pizzas[t.selected.index]
                let image = t.selected.image
                let ingredients = t.data.ingredients
                return (pizza, image, ingredients)
            })
            .asDriver(onErrorDriveWith: Driver<Selection>.never())

        return Output(tableData: sections,
                      selection: selection)
    }
}

extension MenuTableViewModel {
    struct SectionModel {
        var items: [MenuCellViewModel]
    }
}

extension MenuTableViewModel.SectionModel: SectionModelType {
    typealias Item = MenuCellViewModel

    init(original: MenuTableViewModel.SectionModel, items: [Item]) {
        self.items = items
    }
}
