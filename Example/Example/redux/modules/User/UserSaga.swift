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
    
    // to simulate async function
    try? await Task.sleep(nanoseconds: 1_000_000_000)
    
    do{
        let name = "id-" + action.userID + "-dummy-user-" + String( Int.random(in: 0..<100))
        try await put(StoreUserName(name: name))
    }catch {
        print(error)
    }
    
}
