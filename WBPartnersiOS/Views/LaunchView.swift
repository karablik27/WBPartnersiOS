import SwiftUI

// MARK: - Constants

private enum Constants {
    static let imageSize: CGFloat = 160
    static let cornerRadius: CGFloat = 32
    static let offsetY: CGFloat = -20
    static let fadeInDuration: Double = 1.2
    static let totalDelay: Double = 2.4
}

// MARK: - LaunchView
struct LaunchView: View {

    @State private var isReady = false
    @State private var logoOpacity = 0.0

    // MARK: - Body
    var body: some View {
        ZStack {
            if isReady {
                ContentView()
                    .transition(.opacity)
            } else {
                splashScreen
                    .transition(.opacity)
            }
        }
        .onAppear {
            startAnimation()
        }
        .animation(.easeInOut(duration: 0.6), value: isReady)
    }

    // MARK: - Splash Screen
    private var splashScreen: some View {
        VStack {
            Spacer()

            Image("loading")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Constants.imageSize, height: Constants.imageSize)
                .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                .opacity(logoOpacity)
                .offset(y: Constants.offsetY)
                .animation(.easeInOut(duration: Constants.fadeInDuration), value: logoOpacity)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .ignoresSafeArea()
    }

    // MARK: - Animation
    private func startAnimation() {
        withAnimation {
            logoOpacity = 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.totalDelay) {
            withAnimation {
                isReady = true
            }
        }
    }
}
