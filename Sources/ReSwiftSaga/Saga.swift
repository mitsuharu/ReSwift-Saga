//
//  Saga.swift
//  ReSwift-Saga
//
//  Created by Mitsuharu Emoto on 2023/08/26.
//

import ReSwift

/**
 protocal for Sagable Action
 
 @description
 ReSwift-Saga requires to define Actions as struct,
 it does not support enum.
 
 @example
 ```swift
 import ReSwiftSaga

 protocol CounterAction: SagaAction {}

 struct Increase: CounterAction {}
 struct Decrease: CounterAction {}
 struct Assign: CounterAction {
     let count: Int
 }
 ```
 */
public protocol SagaAction: Action {
}

/**
 It is type of function to execute in Saga.
 
 @example
 ```swift
 let requestUserSaga: Saga = { action async in
     guard let action = action as? RequestUser else {
         return
     }
     try? await Task.sleep(nanoseconds: 1_000_000_000)
     try? await put(StoreUserName(name: "user_name"))
 }
 ```
 */
public typealias Saga<T> = (SagaAction) async throws -> T

/**
 It makes a middleware for Saga
 
 @example
 ```swift
 import ReSwift
 import ReSwiftSaga

 func makeAppStore() -> Store<AppState> {
     let sagaMiddleware: Middleware<AppState> = createSagaMiddleware()
     return Store<AppState>(
         reducer: appReducer,
         state: AppState.initialState(),
         middleware: [sagaMiddleware]
     )
 }
 ```
 */
public func createSagaMiddleware<State>() -> Middleware<State> {
    return { dispatch, getState in
        
        // FIXME: To set values, we require to dispatch any actions.
        Channel.shared.dispatch = dispatch
        Channel.shared.getState = getState
        
        return { next in
            return { action in
                if let action = action as? SagaAction {
                    Channel.shared.put(action)
                }
                return next(action)
            }
        }
    }
}
