//
//  LoadingView.swift
//  Diet Assignment
//
//  Created by Swosti Sambit Yadab on 21/06/25.
//

import SwiftUI

struct LoadingView: View {
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                LottieView(name: "Loading", loopMode: .loop)
                    .frame(width: 200, height: 200)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
    }
}

#Preview {
    LoadingView()
}
