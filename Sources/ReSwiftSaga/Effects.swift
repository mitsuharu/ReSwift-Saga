//
//  Effects.swift
// 
//
//  Created by Mitsuharu Emoto on 2023/08/26.
//

import Foundation

public func put(_ action: SagaAction) {
    if let dispatch = Channel.shared.dispatch {
        Task.detached { @MainActor in
            dispatch(action)
        }
    }
}

public func selector<State, T>(_ selector: (State) -> T) async throws -> T {
    if let getState = Channel.shared.getState,
       let state = getState() as? State  {
      return selector(state)
    }
    throw SagaError.invalid
}

@discardableResult
public func call(_ effect: @escaping Saga<Any>, _ arg: SagaAction) async -> Any {
    return await effect(arg)
}

@discardableResult
public func call(_ effect: @escaping Saga<Any>) async -> Any {
    let action = SagaAction()
    return await effect(action)
}

public func fork(_ effect: @escaping Saga<Any>, _ arg: SagaAction) async -> Void {
    Task.detached{
        let _ = await effect(arg)
    }
}

public func fork(_ effect: @escaping Saga<Any>) async -> Void {
    Task.detached{
        let action = SagaAction()
        let _ = await effect(action)
    }
}

@discardableResult
public func take(_ actionType: SagaAction.Type) async -> SagaAction {
    return await withCheckedContinuation { continuation in
        Channel.shared.take(actionType) { action in
            continuation.resume(returning: action)
        }
    }
}

public func takeEvery( _ actionType: SagaAction.Type, saga: @escaping Saga<Any>) {
    Task.detached {
        while true {
            let action = await take(actionType)
            await fork(saga, action)
        }
    }
}

public func takeLatest( _ actionType: SagaAction.Type, saga: @escaping Saga<Any>) {
    let buffer = Buffer()
    Task.detached {
        while true {
            let action = await take(actionType)
            buffer.done()
            buffer.task = Task.detached{
                defer { buffer.done() }
                await call(saga, action)
            }
        }
    }
}

public func takeLeading( _ actionType: SagaAction.Type, saga: @escaping Saga<Any>) {
    let buffer = Buffer()
    Task.detached {
        while true {
            let action = await take(actionType)
            if (buffer.task != nil){
                continue
            }
            buffer.task = Task.detached {
                defer { buffer.done() }
                await call(saga, action)
            }
        }
    }
}
