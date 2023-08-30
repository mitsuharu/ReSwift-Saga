//
//  CounterReducer.swift
//  Example
//
//  Created by Mitsuharu Emoto on 2023/08/26.
//

import Foundation

func counterReducer(action: CounterAction, state: CounterState) -> CounterState {
    
    switch action {
    case _ as Increase:
        return CounterState(count: state.count + 1)
    
    case _ as Decrease:
        return CounterState(count: state.count - 1)
    
    case let action as Assign:
        return CounterState(count: action.count)
    
    case _ as Clear:
        return CounterState(count: 0)

    default:
        return state
    }
}
