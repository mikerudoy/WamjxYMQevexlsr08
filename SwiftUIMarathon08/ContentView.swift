//
//  ContentView.swift
//  SwiftUIMarathon08
//
//  Created by Mike Rudoy on 17/05/2024.
//

import SwiftUI

struct ContentView: View {
    @State var value: Double = 0.5

    @State private var startingValue = 0.5
    @State private var scaleSize = CGSize(width: 1.0, height: 1.0)
    @State private var anchorPoint = UnitPoint(x: 0.5, y: 0.5)

    var body: some View {
        ZStack {
            Image("ios17wallpaper")
                .resizable()
                .blur(radius: 10)
            
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .background(.ultraThinMaterial)
                    Color.white
                        .frame(width: geometry.size.width, height: geometry.size.height * CGFloat(self.value))
                        .cornerRadius(0)
                }
                .cornerRadius(geometry.size.width/3.3)
                .gesture(self.gesture(geometry: geometry).map { _ in () })
            }
            .scaleEffect(scaleSize, anchor: anchorPoint)
            .frame(width: 100, height: 200)
            
        }.ignoresSafeArea()
    }
    
    func gesture(geometry: GeometryProxy) -> some Gesture {
        LongPressGesture(minimumDuration: 0)
        .onEnded { _ in
            self.startingValue = self.value
        }
        .sequenced(before: DragGesture(minimumDistance: 0)
            .onChanged {
                let t = self.startingValue - Double(($0.location.y - $0.startLocation.y) / geometry.size.height)
                withAnimation(.linear(duration: 0.1)) {
                    if t < 0 {
                        anchorPoint = UnitPoint(x: 0.5, y: 0.05)
                        scaleSize = CGSize(
                            width: (t > 0) ? 1.0 : (1.0 + max(t / 10.0, -0.1)),
                            height: min(1.3, max(1, 1 - (t * 0.1)))
                        )
                    } else if t > 1 {
                        anchorPoint = UnitPoint(x: 0.5, y: 0.95)
                        scaleSize = CGSize(
                            width: max(0.9, (t < 1.0) ? 1.0 : (2.0 - min(t * 0.9, 1.1))),
                            height: min(1.3, 1.0 + (t - 1.0) * 0.1)
                        )
                    }
                }
                self.value = min(max(0.0, t), 1.0)
            }.onEnded({ g in
                withAnimation {
                    scaleSize = CGSize(width: 1, height: 1)
                    anchorPoint = UnitPoint(x: 0.5, y: 0.5)
                }
            })
        )
    }
}


#Preview {
    ContentView()
}
