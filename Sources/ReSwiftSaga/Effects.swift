//
//  Effects.swift
//  ReSwift-Saga
//
//  Created by Mitsuharu Emoto on 2023/08/26.
//

import Foundation
import ReSwift

private struct SagaAction: Action {}

/**
 引き数に指定された Action を Store に発行します。
 Saga middleware dispatches Action to the store.
 
 @example
 ```swift
 do {
    try await put(Increase())
 } catch {
    print(error)
 }
 ```
 */
public func put(_ action: Action) async throws {
    guard let dispatch = Bridge.shared.dispatch else{
        throw SagaError.middlewareFailed(message: "SagaMiddleware has not prepared dispatch.")
    }
    Task.detached { @MainActor in
        dispatch(action)
    }
}

/**
 selector 関数を使って、Store から state を取得します。
 Saga middleware invokes selector on the current Store's state.
 
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
        let getState = Bridge.shared.getState,
        let state = getState() as? State else
    {
        throw SagaError.middlewareFailed(message: "SagaMiddleware has not prepared getState.")
    }
    return selector(state)
}

/**
 Saga 関数とその引き数を指定して実行します。
 Saga middleware calls saga function with arguments.
 
 @example
 ```
 do {
    let effect = ...
    let action = ...
    let _ = try await call(effect, action)
 } catch {
    print(error)
 }
 ```
 */
@discardableResult
public func call<T>(_ effect: @escaping Saga<T>, _ arg: Action) async rethrows -> T {
    return try await effect(arg)
}

@discardableResult
public func call<T>(_ effect: @escaping Saga<T>) async rethrows -> T {
    return try await call(effect, SagaAction())
}

/**
 call と同様に Saga 関数とその引き数を指定して実行しますが、処理完了は待ちません。
 Saga middleware performs a non-blocking call on effect.
 
 @discission
 fork は call と異なり関数実行の結果を待たないので await は不要だが、他関数との同様にするため非同期関数にしている。
 本家の js ではすべて yield が付いていた。この処理に await は必要か？不要か？
 
 @example
 ```
 do {
    let effect = ...
    let action = ...
    let _ = try await fork(effect, action)
 } catch {
    print(error)
 }
 ```
 */
public func fork<T>(_ effect: @escaping Saga<T>, _ arg: Action) async rethrows -> Void {
    Task.detached{
        let _ = try await effect(arg)
    }
}

public func fork<T>(_ effect: @escaping Saga<T>) async rethrows -> Void {
    try await fork(effect, SagaAction())
}

/**
 特定の Action が発行されるまで待ち、発行されたらその Action を取得します。
 Saga middleware waits for dispatched specific action.
  
 @example
 ```swift
 while true {
    let action = await take(RequestUser.self)
    print(action)
 }
 ```
 */
@discardableResult
func take(_ actionType: Action.Type) async -> Action {
    if #available(iOS 15, macOS 12, *) {
        let action = await Bridge.shared.take(actionType).value
        return action
    } else {
        return await withCheckedContinuation { continuation in
            Bridge.shared.take(actionType) { action in
                continuation.resume(returning: action)
            }
        }
    }
}

/**
 特定の Action が発行されるたびに、引き数で指定した Saga 関数を実行します。
 Each time to dispatch a specific action, it perform "fork" with saga function and its action.

 @description
 発行のたびに実行されるので、同処理が重複して実行される場合があります。
 
 @example
 ```swift
 await takeEvery(Increase.self, saga: increaseSaga)
 ```
 */
public func takeEvery<T>( _ actionType: Action.Type, saga: @escaping Saga<T>) async {
    Task.detached {
        while true {
            let action = await take(actionType)
            try? await fork(saga, action)
        }
    }
}

/**
 特定の Action が発行されたら、引き数で指定した Saga 関数を実行します。
 takeEvery と同様ですが、関数実行中に新しい Action が発行されたら、
 現在の処理を破棄して、新しい Action で関数を実行します。
 takeLatest is similar to takeEvery.
 If it dispatches new action while saga function is running,
 it discards its function and execute new process.
 
 @example
 ```swift
 await takeLatest(Increase.self, saga: increaseSaga)
 ```
 */
public func takeLatest<T>( _ actionType: Action.Type, saga: @escaping Saga<T>) async {
    let buffer = Buffer()
    Task.detached {
        while true {
            let action = await take(actionType)
            buffer.done()
            buffer.task = Task.detached{
                defer { buffer.done() }
                let _ = try? await call(saga, action)
            }
        }
    }
}

/**
 特定の Action が発行されたら、引き数で指定した Saga 関数を実行します。
 takeEvery と同様ですが、関数実行中に新しい Action が発行されても、
 現在の処理が完了するまで、新しい処理は実行しません。
 takeLeading is similar to takeEvery.
 If it dispatches new action while saga function is running,
 it will not be executed until its function is completed.
 
 @example
 ```swift
 await takeLeading(Increase.self, saga: increaseSaga)
 ```
 */
public func takeLeading<T>( _ actionType: Action.Type, saga: @escaping Saga<T>) async {
    let buffer = Buffer()
    Task.detached {
        while true {
            let action = await take(actionType)
            if (buffer.task != nil){
                continue
            }
            buffer.task = Task.detached {
                defer { buffer.done() }
                let _ = try? await call(saga, action)
            }
        }
    }
}
