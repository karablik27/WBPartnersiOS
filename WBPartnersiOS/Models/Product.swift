import Foundation
import SwiftData

// MARK: - Product Model
@Model
final class Product: Identifiable {
    
    // MARK: - Properties
    @Attribute(.unique) var id: Int
    var name: String
    var category: String
    var article: String
    var wbArticle: String
    var originalPrice: Double?
    var discount: Double?
    var imageUrl: String?

    // MARK: - Init
    init(id: Int, name: String, category: String, article: String, wbArticle: String, originalPrice: Double? = nil, discount: Double? = nil,
        imageUrl: String? = nil) {
        self.id = id
        self.name = name
        self.category = category
        self.article = article
        self.wbArticle = wbArticle
        self.originalPrice = originalPrice
        self.discount = discount
        self.imageUrl = imageUrl
    }

    // MARK: - Computed Properties
    var discountedPrice: Double? {
        guard let originalPrice, let discount else { return nil }
        return originalPrice * (1 - discount / 100)
    }
}
