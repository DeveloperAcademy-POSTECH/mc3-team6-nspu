//
//  LoginView_malty.swift
//  OrrNyan
//
//  Created by YouiHyon Kim on 2023/07/19.
//

import SwiftUI

struct LoginView_malty: View {
    var body: some View {
		
		VStack{
			LottieView(filename: "firstCat")
				.border(.red)
				.frame(height: 330)
				.frame(maxWidth:.infinity)
				.padding(.horizontal, 30)
				.frame(maxWidth: .infinity)

			
		}
    }
}

struct LoginView_malty_Previews: PreviewProvider {
    static var previews: some View {
        LoginView_malty()
    }
}
