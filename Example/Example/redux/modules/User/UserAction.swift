//
//  UserAction.swift
//  Example
//
//  Created by Mitsuharu Emoto on 2023/08/26.
//

import Foundation
import ReSwiftSaga

protocol UserAction: SagaAction {}

struct RequestUser: UserAction {
    let userID: String
}

struct StoreUserName: UserAction {
    let name: String
}

struct ClearUser: UserAction {
}

