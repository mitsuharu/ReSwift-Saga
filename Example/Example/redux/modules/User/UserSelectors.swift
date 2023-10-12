//
//  UserSelectors.swift
//  Example
//
//  Created by Mitsuharu Emoto on 2023/08/26.
//

import Foundation

func selectUserID(store: AppState) -> String {
    store.user.userID ?? ""
}

func selectUserName(store: AppState) -> String {
    store.user.name ?? ""
}
