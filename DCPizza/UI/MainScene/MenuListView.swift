//
//  MenuListView.swift
//  DCPizza
//
//  Created by Balázs Kilvády on 6/9/20.
//  Copyright © 2020 kil-dev. All rights reserved.
//

import SwiftUI
import Combine
import Domain
import Resolver
import Introspect

struct MenuListView: View, Resolving {
    @InjectedObject private var _viewModel: MenuListViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(_viewModel.listData) { vm in
                    ZStack {
                        MenuRow(viewModel: vm)
                        NavigationLink(destination:
                            self.resolver.resolve(
                                IngredientsListView.self,
                                args: self._viewModel.pizza(at: vm.index)
                            )
                        ) {
                            EmptyView()
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .listRowInsets(EdgeInsets())
                }
            }
            .introspectTableView {
                $0.separatorStyle = .none
            }
            .navigationBarTitle("NENNO'S PIZZA")
            .navigationBarItems(
                leading: NavigationLink(destination:
                    resolver.resolve(CartListView.self)
                ) {
                    Image("ic_cart_navbar")
                },
                trailing: NavigationLink(destination:
                    resolver.resolve(IngredientsListView.self,
                                     args: Just(Pizza()).eraseToAnyPublisher())
                ) {
                    Image(systemName: "plus")
                })
            .sheet(isPresented: $_viewModel.showAdded) {
                AddedView()
            }
        }
    }
}

struct MenuListView_Previews: PreviewProvider {
    static var previews: some View {
        Resolver.switchToNetworkless()
        return Resolver.resolve(MenuListView.self)
    }
}
