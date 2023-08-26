//
//  UserSaga.swift
//  Example
//
//  Created by Mitsuharu Emoto on 2023/08/26.
//

import Foundation
import ReSwiftSaga

let userSaga: Saga = { _ in
    takeLeading(RequestUser.self, saga: requestUserSaga)
}

let requestUserSaga: Saga = { action async in
    guard let action = action as? RequestUser else {
        return
    }
    
    try? await Task.sleep(nanoseconds: 1_000_000_000)
    
    let name = "id-" + action.userID + "-dummy-user-" + String( Int.random(in: 0..<100))
    put(StoreUserName(name: name))
}
