//
//  MovingBlob.swift
//  VaultClient
//
//  Created by Gökalp Gürocak on 31.03.2026.
//


import SwiftUI

struct MovingBlob: View {
    let color: Color
    let proxy: GeometryProxy
    
    @State private var position: CGPoint
    @State private var scale: CGFloat = 1.0
    @State private var timer: Timer?
    
    let animationDuration: Double = Double.random(in: 6...12)
    
    init(color: Color, proxy: GeometryProxy) {
        self.color = color
        self.proxy = proxy
        let initialX = CGFloat.random(in: 0...proxy.size.width)
        let initialY = CGFloat.random(in: 0...proxy.size.height)
        _position = State(initialValue: CGPoint(x: initialX, y: initialY))
    }
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 400, height: 400)
            .scaleEffect(scale)
            .position(position)
            .onAppear { startMoving() }
            .onDisappear {
                timer?.invalidate()
                timer = nil
            }
            .drawingGroup()
    }
    
    func startMoving() {
        withAnimation(.easeInOut(duration: animationDuration)) {
            position = randomPosition()
            scale = CGFloat.random(in: 0.8...1.5)
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) { _ in
            withAnimation(.easeInOut(duration: animationDuration)) {
                position = randomPosition()
                scale = CGFloat.random(in: 0.8...1.5)
            }
        }
    }
    
    func randomPosition() -> CGPoint {
        CGPoint(
            x: CGFloat.random(in: 0...proxy.size.width),
            y: CGFloat.random(in: 0...proxy.size.height)
        )
    }
}
