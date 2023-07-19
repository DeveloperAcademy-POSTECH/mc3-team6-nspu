//
//  MainBottomView.swift
//  OrrNyan
//
//  Created by qwd on 2023/07/16.
//

import SwiftUI

struct MainBottomView: View {
    var body: some View {
        //MARK: - myPage NavigationLink로 할 지 논의
        Image(systemName: "person.fill")
            .resizable()
            .frame(width:40,height:40)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 250))
    }
}

struct MainBottomView_Previews: PreviewProvider {
    static var previews: some View {
        MainBottomView()
    }
}
