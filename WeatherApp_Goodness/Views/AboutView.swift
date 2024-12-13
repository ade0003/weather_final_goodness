//
//  AboutView.swift
//  WeatherApp_Goodness
//
//  Created by Goodness Ade on 2024-12-12.
//

import SwiftUI

struct AboutView: View {
    @State private var tapCount = 0
    @State private var showKidPicture = false
    
    var body: some View {
        NavigationStack { // Optional: Wrap in NavigationStack if you want navigation capabilities
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack {
                    Text("Weather App")
                        .font(.largeTitle)
                        .foregroundColor(.white) // Optional: Change text color for better contrast
                    Text("Version 1.0")
                        .font(.subheadline)
                        .foregroundColor(.white) // Optional: Change text color for better contrast
                    
                    Image("me")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 100)
                        .clipShape(Circle())
                        .onTapGesture {
                            tapCount += 1
                            if tapCount == 3 {
                                withAnimation(.easeIn(duration: 0.5)) { // Animate the appearance
                                    showKidPicture.toggle()
                                }
                                tapCount = 0
                            }
                        }
                    
                    if showKidPicture {
                        Image("kid")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 100)
                            .clipShape(Circle())
                            .transition(.scale) // Transition effect
                            .animation(.easeInOut(duration: 0.5), value: showKidPicture) // Animation for the transition
                    }
                    
                    Text("Created by Goodness Ade")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white) // Optional: Change text color for better contrast
                }
                .padding() // Add padding to the VStack for better layout
            }
        }
    }
}

#Preview {
    AboutView()
}
