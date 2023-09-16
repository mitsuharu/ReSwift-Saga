//
//  AppSaga.swift
//  Example
//
//  Created by Mitsuharu Emoto on 2023/08/26.
//

import Foundation
import ReSwiftSaga

let appSage: Saga = { _ async in
    do {
        try await fork(counterSaga)
        try await fork(userSaga)
        try await fork(toastSaga)
    } catch {
        print(error)
    }
}
