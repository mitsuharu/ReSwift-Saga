//
//  CounterSelectors.swift
//  Example
//
//  Created by Mitsuharu Emoto on 2023/08/26.
//

import Foundation

func selectCount(store: AppState) -> Int {
    store.counter.count
}
