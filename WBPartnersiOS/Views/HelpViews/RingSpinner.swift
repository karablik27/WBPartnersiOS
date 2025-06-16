import SwiftUI

// MARK: - RingSpinner
struct RingSpinner: View {
    
    @State private var isAnimating = false

    // MARK: - Configuration
    var color: Color = Color(red: 0x9A / 255, green: 0x41 / 255, blue: 0xFE / 255)
    var lineWidth: CGFloat = 4
    var size: CGFloat = 40

    // MARK: - Body
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(color, lineWidth: lineWidth)
            .frame(width: size, height: size)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .onAppear {
                withAnimation(.linear(duration: 0.8).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }
}
