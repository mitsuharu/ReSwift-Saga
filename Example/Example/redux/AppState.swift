//
//  AppState.swift
//  Example
//
//  Created by Mitsuharu Emoto on 2023/08/26.
//

import Foundation

struct AppState {
    let counter: CounterState
    let user: UserState

    static func initialState() -> AppState {
        AppState(
            counter: CounterState.initialState(),
            user: UserState.initialState()
        )
    }
}
