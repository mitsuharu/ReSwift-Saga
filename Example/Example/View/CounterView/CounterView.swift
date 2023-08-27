//
//  CounterView.swift
//  Example
//
//  Created by Mitsuharu Emoto on 2023/08/26.
//

import SwiftUI

struct CounterView: View {
    
    @ObservedObject private var viewModel = CounterViewModel()
    
    var body: some View {
        VStack{
            HStack{
                Button("increase") {
                    viewModel.increase()
                }
                Button("decrease") {
                    viewModel.decrease()
                }
                Button("move") {
                    viewModel.move(count: 100)
                }
                Button("clear") {
                    viewModel.clear()
                }
            }.padding(10)
            Text("Count: \(viewModel.count)")
        }
    }
}

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView()
    }
}
