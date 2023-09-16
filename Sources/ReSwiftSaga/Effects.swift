//
//  Effects.swift
//  ReSwift-Saga
//
//  Created by Mitsuharu Emoto on 2023/08/26.
//

import Foundation

private struct Sagable: SagaAction {}

/**
 Saga middlware dispatches Action to the store.
 
 @example
 ```swift
 do {
    try await put(Increase())
 } catch {
    print(error)
 }
 ```
 */
public func put(_ action: SagaAction) async throws {
    guard let dispatch = Channel.shared.dispatch else{
        throw SagaError.middlewareFailed(message: "SagaMiddleware has not prepared dispatch.")
    }
    Task.detached { @MainActor in
        dispatch(action)
    }
}

/**
 Saga middlware invokes selector on the current Store's state.
 
 @example
 ```swift
 do {
    let count = try await selector(selectorCount)
 } catch {
    print(error)
 }
 ```
 */
public func selector<State, T>(_ selector: (State) -> T) async throws -> T {
    guard
        let getState = Channel.shared.getState,
        let state = getState() as? State else
    {
        throw SagaError.middlewareFailed(message: "SagaMiddleware has not prepared getState.")
    }
    return selector(state)
}

@discardableResult
public func call<T>(_ effect: @escaping Saga<T>, _ arg: SagaAction) async -> T {
    return await effect(arg)
}

@discardableResult
public func call<T>(_ effect: @escaping Saga<T>) async -> T {
    return await effect(Sagable())
}

public func fork<T>(_ effect: @escaping Saga<T>, _ arg: SagaAction) async -> Void {
    Task.detached{
        let _ = await effect(arg)
    }
}

public func fork<T>(_ effect: @escaping Saga<T>) async -> Void {
    Task.detached{
        let _ = await effect(Sagable())
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

public func takeEvery<T>( _ actionType: SagaAction.Type, saga: @escaping Saga<T>) {
    Task.detached {
        while true {
            let action = await take(actionType)
            await fork(saga, action)
        }
    }
}

public func takeLatest<T>( _ actionType: SagaAction.Type, saga: @escaping Saga<T>) {
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

public func takeLeading<T>( _ actionType: SagaAction.Type, saga: @escaping Saga<T>) {
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
