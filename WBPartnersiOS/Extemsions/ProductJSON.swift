// MARK: - Codable
extension Product: Codable {
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case id, name, category, article, wbArticle, originalPrice, discount, imageUrl
    }

    // MARK: - Decodable
    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let category = try container.decode(String.self, forKey: .category)
        let article = try container.decode(String.self, forKey: .article)
        let wbArticle = try container.decode(String.self, forKey: .wbArticle)
        let originalPrice = try container.decodeIfPresent(Double.self, forKey: .originalPrice)
        let discount = try container.decodeIfPresent(Double.self, forKey: .discount)
        let imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)

        self.init(
            id: id,
            name: name,
            category: category,
            article: article,
            wbArticle: wbArticle,
            originalPrice: originalPrice,
            discount: discount,
            imageUrl: imageUrl
        )
    }

    // MARK: - Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(category, forKey: .category)
        try container.encode(article, forKey: .article)
        try container.encode(wbArticle, forKey: .wbArticle)
        try container.encodeIfPresent(originalPrice, forKey: .originalPrice)
        try container.encodeIfPresent(discount, forKey: .discount)
        try container.encodeIfPresent(imageUrl, forKey: .imageUrl)
    }
}
