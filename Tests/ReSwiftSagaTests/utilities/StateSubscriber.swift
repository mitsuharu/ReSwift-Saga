//
//  StateSubscriber.swift
//  
//
//  Created by Mitsuharu Emoto on 2023/08/27.
//

import Foundation
import ReSwift

// see: https://github.com/ReSwift/ReSwift/blob/master/ReSwiftTests/StoreSubscriberTests.swift#L458
class StateSubscriber<T>: StoreSubscriber {
    var value: T!

    func newState(state: T) {
        value = state
    }
}
