import SwiftUI

// MARK: - EmptyStateView
struct EmptyStateView: View {
    
    var body: some View {
        VStack(spacing: 16) {
            Image("empty-state")
                .resizable()
                .scaledToFit()
                .frame(width: 280)

            Text("Ничего не найдено")
                .font(.body)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGray6))
    }
}
