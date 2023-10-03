//
//  ToastAction.swift
//  Example
//
//  Created by Mitsuharu Emoto on 2023/09/16.
//

import Foundation
import ReSwift

protocol ToastAction: Action {}

struct ShowToast: ToastAction {
    let message: String
}
