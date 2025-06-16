// MARK: - ProductFilter
enum ProductFilter: String, CaseIterable, Identifiable {
    case all = "Все товары"
    case noPrice = "Товары без цены"

    var id: String { rawValue }
}
