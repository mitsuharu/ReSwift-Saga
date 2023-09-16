//
//  RootView.swift
//  Example
//
//  Created by Mitsuharu Emoto on 2023/08/26.
//

import SwiftUI
import AlertToast

struct RootView: View {
    
    @ObservedObject private var viewModel = ToastViewModel.shared
    
    var body: some View {
        NavigationView {
            VStack{
                CounterView()
                UserView()
            }.toast(isPresenting: $viewModel.showToast) {
                AlertToast(type: .regular, title: viewModel.message)
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
