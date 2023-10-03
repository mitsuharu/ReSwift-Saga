//
//  InternalBridge.swift
//  ReSwift-Saga
//
//  Created by Mitsuharu Emoto on 2023/08/26.
//

import Foundation
import Combine
import ReSwift

/**
 InternalBridge
 - Redux と Redux Saga 間のデータ受取を管理する
 - Action の発行や監視を行う
 */
final class InternalBridge {
    
    static let shared = InternalBridge()
    private let subject = PassthroughSubject<Action, Error>()
    
    // createSagaMiddleware で Redux 内部の dispatch を取得する
    // TODO: Optional を外したい
    var dispatch: DispatchFunction? = nil
    
    // createSagaMiddleware で Redux 内部の getState を取得する
    // TODO: Optional を外したい
    // TODO: Any ではなく State を指定したいが、どのタイミングで行う？
    var getState: (() -> Any?)? = nil
    
    /**
     action を発行する
     */
    func put(_ action: Action){
        subject.send(action)
    }
    
    /**
     特定の action を監視する
     */
    func take(_ actionType: Action.Type, receive: @escaping (_ action: Action) -> Void ){
        // 監視は一度限りで行い、検出後は破棄する
        // 破棄しないと、検出した action を対応にした場合、withCheckedContinuation で二重呼び出しにカウントされクラッシュする
        var cancellable: AnyCancellable? = nil
        cancellable = subject.filter {
            type(of: $0) == actionType
        }.sink { [weak self] in
            self?.complete($0)
            cancellable?.cancel()
        } receiveValue: {
            receive($0)
            cancellable?.cancel()
        }
    }
    
    /**
     エラー時の処理
     TODO: エラーを投げるかは検討
     */
    private func complete(_ completion: Subscribers.Completion<Error>){
        switch completion {
        case .finished:
            print("InternalBridge#complete finished")
        case .failure(let error):
            assertionFailure("InternalBridge#complete failure \(error)")
        }
    }
}
