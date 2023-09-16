ReSwift-Saga
==

- ReSwift 向けに [Redux Saga](https://redux-saga.js.org/) を再現したプロジェクトです
- 完全再現ではなく、設計思想を参考にしつつ、一部機能を再現しています

## Develop

- Xcode 14.3.1
- iOS 13.0 以上をサポートしています

### Contributing

- 準備中


## EFFECTS

現在、下記の effect をサポートしています。

- put
- selector
- call
- fork
- take
- takeEvery
- takeLatest
- takeLeading

## Installation

We requires [ReSwift](https://github.com/ReSwift/ReSwift) (~> 6.1.0).

### Swift Package Manager

Xcode から設定する、または `Package.swift` の `dependencies ` を編集してください。

```Swift
dependencies: [
	.Package(url: "https://github.com/mitsuharu/ReSwift-Saga.git", upToNextMajor: "x.y.z")
]
```

### CocoaPods

not yet


## USAGE

- 詳しくは Example を見てください

### Redux

- [ReSwift](https://github.com/ReSwift/ReSwift) 6.1.1 を利用しています。
- Store の生成時に `createSagaMiddleware` で生成した middleware を追加します。

```swift
func makeAppStore() -> Store<AppState> {
    
    // Saga 用の middeware を生成する
    let sagaMiddleware: Middleware<AppState> = createSagaMiddleware()
    
    let store = Store<AppState>(
        reducer: appReducer,
        state: AppState.initialState(),
        middleware: [sagaMiddleware]
    )
    return store
}
```


### Action

- Action は struct で生成します
- enum はサポートしていません


```swift
import ReSwiftSaga

protocol UserAction: SagaAction {}

struct RequestUser: UserAction {
    let userID: String
}

struct StoreUserName: UserAction {
    let name: String
}
```

### Saga

```swift
let userSaga: Saga = { _ in
    takeEvery(RequestUser.self, saga: requestUserSaga)
}

let requestUserSaga: Saga = { action async in
    guard let action = action as? RequestUser else {
        return
    }
    
    try? await Task.sleep(nanoseconds: 1_000_000_000)
    
    let name = "dummy-user-" + String( Int.random(in: 0..<100))
    try? await put(StoreUserName(name: name))
}
```


### dispatch

- ViewModel での実装例です

```swift
import Foundation
import ReSwift

final class UserViewModel: ObservableObject, StoreSubscriber {
    @Published private(set) var name: String = ""

    init() {
        appStore.subscribe(self) {
            $0.select { selectUserName(store: $0) }
        }
    }

    deinit {
        appStore.unsubscribe(self)
    }

    internal func newState(state: String) {
        self.name = state
    }
    
    public func requestUser() {
        appStore.dispatch(RequestUser(userID: "1234"))
    }    
}
```
