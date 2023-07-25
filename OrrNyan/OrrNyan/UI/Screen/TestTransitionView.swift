//
//  TestTransitionView.swift
//  OrrNyan
//
//  Created by 박상원 on 2023/07/19.
//

// MARK: - Transition test용 View입니다

import SwiftUI

struct TestTransitionView: View {
    @Namespace var nameSpace
    var body: some View {
        Image("StageSt01")
            .matchedGeometryEffect(id: "StageStImage0", in: nameSpace)
    }
}

struct TestTransitionView_Previews: PreviewProvider {
    static var previews: some View {
        TestTransitionView()
    }
}
