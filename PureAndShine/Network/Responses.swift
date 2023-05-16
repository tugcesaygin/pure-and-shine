//
//  Responses.swift
//  PureAndShine
//
//  Created by Tuğçe Saygın on 4.04.2023.
//

import Foundation

struct Product: Codable {
    let id: Int?
    let brand, name: String?
    let ingredientList: [String]?

    enum CodingKeys: String, CodingKey {
        case id, brand, name
        case ingredientList = "ingredient_list"
    }
}

struct ProductDetails: Codable {
    let id: Int
    let ingredient: String
    
}
