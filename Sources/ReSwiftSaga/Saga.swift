//
//  Saga.swift
// 
//
//  Created by Mitsuharu Emoto on 2023/08/26.
//

import ReSwift

/**
 Action のクラス
 一般的に enum や struct が使われることが多いが、
 Actionのmoduleごとのグルーピングなどに継承を利用するためにclassを利用する
 */
public class SagaAction: Action {
}

/**
 Sagaで実行する関数の型
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
