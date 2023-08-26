//
//  CounterState.swift
//  Example
//
//  Created by Mitsuharu Emoto on 2023/08/26.
//

import Foundation

struct CounterState {
    let count: Int

    static func initialState() -> CounterState {
        CounterState(count: 0)
    }
}
