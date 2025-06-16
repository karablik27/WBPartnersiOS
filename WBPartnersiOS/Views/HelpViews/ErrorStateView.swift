import SwiftUI

// MARK: - ErrorStateView
struct ErrorStateView: View {
    
    var onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image("error-state")
                .resizable()
                .scaledToFit()
                .frame(width: 280)

            Text("Что-то пошло не так")
                .font(.body)
                .foregroundColor(.primary)

            Text("Попробуйте позднее")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Button(action: onRetry) {
                Label("Обновить", systemImage: "arrow.clockwise")
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color(red: 0.6, green: 0.25, blue: 1.0))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGray6))
    }
}
