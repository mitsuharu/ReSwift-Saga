//
//  Util.swift
//  
//
//  Created by Mitsuharu Emoto on 2023/08/27.
//

import Foundation
import ReSwift
import XCTest

// see: https://github.com/ReSwift/ReSwift/blob/master/ReSwiftTests/StoreSubscriberTests.swift#L458
class TestFilteredSubscriber<T>: StoreSubscriber {
    var receivedValue: T!
    var newStateCallCount = 0

    func newState(state: T) {
        receivedValue = state
        newStateCallCount += 1
    }
}
