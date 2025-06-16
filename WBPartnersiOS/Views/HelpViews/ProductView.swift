import SwiftUI

// MARK: - ProductView
struct ProductView: View {

    let product: Product
    let onMoreTapped: () -> Void


    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // MARK: Top Section
            HStack(alignment: .top, spacing: 12) {
                AsyncImage(url: URL(string: product.imageUrl ?? "")) { phase in
                    if let img = phase.image {
                        img
                            .resizable()
                            .scaledToFill()
                    } else {
                        Color(.secondarySystemFill)
                    }
                }
                .frame(width: 84, height: 84)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 4) {
                    Text(product.category)
                        .font(.caption2.weight(.medium))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color(.systemGray5))
                        )

                    Text(product.name)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.primary)
                        .lineLimit(2)

                    Text("Арт. \(product.article)")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text("Арт. WB \(product.wbArticle)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer(minLength: 4)

                Button(action: onMoreTapped) {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .foregroundColor(.secondary)
                        .padding(8)
                }
            }

            // MARK: Price Rows
            priceRow(
                title: "Цена продавца до скидки",
                value: formatted(product.originalPrice, suffix: "₽")
            )
            priceRow(
                title: "Скидка продавца",
                value: formatted(product.discount, suffix: "%")
            )
            if let discounted = product.discountedPrice {
                priceRow(
                    title: "Цена со скидкой",
                    value: formatted(discounted, suffix: "₽"),
                    isBold: true
                )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
        )
        .shadow(color: Color.black.opacity(0.04), radius: 4, y: 2)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }

    // MARK: - Private Views
    @ViewBuilder
    private func priceRow(
        title: String,
        value: String,
        isBold: Bool = false
    ) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text(title + ":")
                .font(.footnote)
                .foregroundColor(.primary)
                .lineLimit(1)
                .layoutPriority(1)

            Rectangle()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [2, 4]))
                .foregroundColor(Color(.systemGray4))
                .frame(maxWidth: .infinity, maxHeight: 1)

            Text(value)
                .font(.footnote)
                .fontWeight(isBold ? .semibold : .regular)
                .foregroundColor(.primary)
        }
    }

    // MARK: - Formatting
    private func formatted(_ v: Double?, suffix: String) -> String {
        guard let v else { return "—" }
        let i = Int(v.rounded())
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        fmt.groupingSeparator = " "
        return (fmt.string(from: i as NSNumber) ?? "\(i)") + " " + suffix
    }
}
