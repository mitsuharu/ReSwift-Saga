//
//  Saga.swift
// 
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
 Saga で実行する関数の型
 */
public typealias Saga<T> = (SagaAction) async -> T

/**
 Saga 向けの middleware
 */
public func createSagaMiddleware<State>() -> Middleware<State> {
    return { dispatch, getState in
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
