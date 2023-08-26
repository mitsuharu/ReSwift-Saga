//
//  AppSaga.swift
//  Example
//
//  Created by Mitsuharu Emoto on 2023/08/26.
//

import Foundation
import ReSwiftSaga

let appSage: Saga = { _ async in
    await fork(counterSaga)
    await fork(userSaga)
}
