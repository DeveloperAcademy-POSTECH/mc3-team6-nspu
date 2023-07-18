//
//  MainParallaxView.swift
//  OrrNyan
//
//  Created by qwd on 2023/07/18.
//

import SwiftUI

struct MainParallaxView: View {
    var body: some View {
        ZStack(){
            Image("StageSt01")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .shadow(radius: 5)
        }
    }
}

struct MainParallaxView_Previews: PreviewProvider {
    static var previews: some View {
        MainParallaxView()
    }
}
