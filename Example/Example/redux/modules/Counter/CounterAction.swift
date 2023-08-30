//
//  CounterAction.swift
//  Example
//
//  Created by Mitsuharu Emoto on 2023/08/26.
//

import Foundation
import ReSwiftSaga

protocol CounterAction: SagaAction {}

struct Increase: CounterAction {}
struct Decrease: CounterAction {}
struct Assign: CounterAction {
    let count: Int
}
struct Clear: CounterAction {}


