//
//  RootView.swift
//  Example
//
//  Created by Mitsuharu Emoto on 2023/08/26.
//

import SwiftUI

struct RootView: View {
        
    var body: some View {
        NavigationView {
            VStack{
                CounterView()
                UserView()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .modifier(ToastModifier())
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
