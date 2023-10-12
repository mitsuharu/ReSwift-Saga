//
//  UserViewModel.swift
//  Example
//
//  Created by Mitsuharu Emoto on 2023/08/26.
//

import Foundation
import ReSwift

final class UserViewModel: ObservableObject, StoreSubscriber {
        
    typealias StoreSubscriberStateType = (userID: String, name: String)
    
    @Published private(set) var userID: String = ""
    @Published private(set) var name: String = ""

    init() {
        appStore.subscribe(self) {
            $0.select { (selectUserID(store: $0), selectUserName(store: $0)) }
        }
    }

    deinit {
        appStore.unsubscribe(self)
    }

    func newState(state: (userID: String, name: String)) {
        self.userID = state.userID
        self.name = state.name
    }
    
    public func requestUser() {
        appStore.dispatch(RequestUser(userID: "1234"))
    }
    
    public func showByToast() {
        let user = userID.isEmpty ? "unknown user" : "ID \(userID)"
        let message = "\(user)\'s name is " + (name.isEmpty ? "none" : name)
        appStore.dispatch(ShowToast(message: message))
    }
    
    public func clearUser() {
        appStore.dispatch(ClearUser())
    }
    
}
