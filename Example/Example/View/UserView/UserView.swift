//
//  UserView.swift
//  Example
//
//  Created by Mitsuharu Emoto on 2023/08/26.
//

import SwiftUI

struct UserView: View {
    
    @ObservedObject private var viewModel = UserViewModel()
    
    var body: some View {
        VStack{
            HStack{
                Button("requestUser") {
                    viewModel.requestUser()
                }
                Button("clearUser") {
                    viewModel.clearUser()
                }
            }.padding(10)
            Text("User name: \(viewModel.name)")
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
