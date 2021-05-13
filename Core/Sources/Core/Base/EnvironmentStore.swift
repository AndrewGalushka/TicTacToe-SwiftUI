//
//  EnvironmentStore.swift
//  TicTacToe
//
//  Created by Andrii Halushka on 14.05.2021.
//

import SwiftUI

public typealias AppStore = Store<AppState>

public class EnvironmentStore: ObservableObject {
    let store: Store<AppState>
    
    @Published private(set) var state: AppState
    
    public init(store: Store<AppState>) {
        self.store = store
        self.state = store.state
        
        store.observe(
            with: CommandWith(
                action: { [weak self]
                    state in self?.state = state
                }
            ).dispatched(on: .main)
        )
    }
    
    public func dispatch(_ action: Action) {
        store.dispatch(action: action)
    }
    
    public func bind(_ action: Action, id: String) -> Command {
        Command(id: id) { [weak self] in
            self?.dispatch(action)
        }
    }
    
    public func bind<T>(_ action: @escaping (T) -> Action, id: String) -> CommandWith<T> {
        CommandWith<T>(id: id) { [weak self] argument in
            self?.dispatch(action(argument))
        }
    }
}

enum EnvironmentStoreLocator {
    private static var store: EnvironmentStore?
    
    public static func populate(with store: EnvironmentStore) {
        self.store = store
    }
    
    public static var shared: EnvironmentStore {
        guard let store = store else {
            fatalError("Store is not populated into locator")
        }
        
        return store
    }
}
