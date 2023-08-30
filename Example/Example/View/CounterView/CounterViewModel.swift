//
//  CounterViewModel.swift
//  Example
//
//  Created by Mitsuharu Emoto on 2023/08/26.
//

import Foundation
import ReSwift

final class CounterViewModel: ObservableObject, StoreSubscriber {
    @Published private(set) var count: Int = 0

    init() {
        appStore.subscribe(self) {
            $0.select { selectCount(store: $0) }
        }
    }

    deinit {
        appStore.unsubscribe(self)
    }

    internal func newState(state: Int) {
        self.count = state
    }
    
    public func increase() {
        appStore.dispatch(Increase())
    }
    
    public func decrease() {
        appStore.dispatch(Decrease())
    }
    
    public func move(count: Int) {
        appStore.dispatch(Assign(count: count))
    }

    public func clear() {
        appStore.dispatch(Clear())
    }
}
