//
//  Error.swift
//  
//
//  Created by Mitsuharu Emoto on 2023/09/16.
//

import Foundation


public enum SagaError: Error {
    
    /**
     Middleware に起因したエラーです。
     The error was caused from Middleware.
     */
    case middlewareFailed(message: String)
    
    /**
     Saga に起因したエラーです。
     The error was caused from Saga.
     */
    case sagaFailed(message: String)
    
    case unknown
}
