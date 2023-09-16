//
//  ReduxModules.swift
//  
//
//  Created by Mitsuharu Emoto on 2023/08/27.
//

import Foundation
import ReSwift
@testable import ReSwiftSaga

struct State {
    let count: Int
    static func initialState() -> State {
        State(count: 0)
    }
}

struct Increase: SagaAction {}
struct Decrease: SagaAction {}
struct Move: SagaAction { let count: Int }
struct Clear: SagaAction {}

func reducer(action: Action, state: State?) -> State {

    let state = state ?? State.initialState()

    var nextCount = state.count

    switch action {
    case _ as Increase:
        nextCount += 1

    case _ as Decrease:
        nextCount += 1
    
    case let action as Move:
        nextCount = action.count
        
    case _ as Clear:
        nextCount = 0
    default:
        break
    }
    
    return State(count: nextCount)
}

func makeStore() -> Store<State> {
    
    let sagaMiddleware: Middleware<State> = createSagaMiddleware()
    
    let store = Store<State>(
        reducer: reducer,
        state: State.initialState(),
        middleware: [sagaMiddleware]
    )

//    Task.detached {
//        await fork(appSage)
//    }
    
    return store
}
