//
//  CounterAction.swift
//  Example
//
//  Created by Mitsuharu Emoto on 2023/08/26.
//

import Foundation
import ReSwiftSaga

class CounterAction: SagaAction {}

final class Increase: CounterAction {}
final class Decrease: CounterAction {}
final class Move: CounterAction {
    let count: Int
    init(count: Int) {
        self.count = count
    }
}
final class Clear: CounterAction {}

