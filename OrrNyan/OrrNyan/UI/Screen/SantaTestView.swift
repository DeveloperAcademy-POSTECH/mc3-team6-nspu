//
//  SantaTestView.swift
//  OrrNyan
//
//  Created by Park Jisoo on 2023/07/27.
//

import SwiftUI

struct SantaTestView: View {
    var body: some View {
        NavigationView{
            NavigationLink("Settings"){
                SettingPopupView()
            }
        }
    }
}

struct SantaTestView_Previews: PreviewProvider {
    static var previews: some View {
        SantaTestView()
    }
}
