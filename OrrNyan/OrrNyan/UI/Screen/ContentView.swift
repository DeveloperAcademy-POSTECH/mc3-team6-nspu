//
//  ContentView.swift
//  OrrNyan
//
//  Created by Jay on 2023/07/12.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("userId") var userId: String?

    var body: some View {
        VStack {
            // test
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            LoginView()
            if userId == nil {
                Text("유저 없다")
            } else {
                Text("유저 있다")
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
