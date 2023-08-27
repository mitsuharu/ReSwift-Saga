//
//  UserState.swift
//  Example
//
//  Created by Mitsuharu Emoto on 2023/08/26.
//

import Foundation

struct UserState {
    let userID: String?
    let name: String?

    static func initialState() -> UserState {
        UserState(userID: nil, name: nil)
    }
}
