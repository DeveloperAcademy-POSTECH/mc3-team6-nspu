//
//  SantaTestView.swift
//  OrrNyan
//
//  Created by Park Jisoo on 2023/07/27.
//
//
import SwiftUI

struct SantaTestView: View {
    
    @State private var showSettingView = false
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        VStack{
            Button(action: {
                self.showSettingView = true
            }){
                Text("나타나라").bold()
            }
            
        }
        .sheet(isPresented: self.$showSettingView) {
            SettingPopupView()
                .environment(\.scenePhase, scenePhase)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        
    }
}
struct SantaTestView_Previews: PreviewProvider {
    static var previews: some View {
        SantaTestView()
    }
}

