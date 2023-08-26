//
//  UserAction.swift
//  Example
//
//  Created by Mitsuharu Emoto on 2023/08/26.
//

import Foundation
import ReSwiftSaga

class UserAction: SagaAction {

}

class RequestUser: UserAction {
    let userID: String
    init(userID: String) {
        self.userID = userID
    }
}

class StoreUserName: UserAction {
    let name: String
    init(name: String) {
        self.name = name
    }
}

class ClearUser: UserAction {
    
}

