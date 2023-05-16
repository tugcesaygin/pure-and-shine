//
//  EndpointType.swift
//  PureAndShine
//
//  Created by Tuğçe Saygın on 3.04.2023.
//

import Foundation

enum EndpointType{
    case products
    case ingredients
    case cart
    case addToCart(productId: Int)
    case removeFromCart(productId: Int)
    
    private static let cartId = 1
    
    var endpointValue : String{
        switch self {
        case .products:
            return "/products"
        case .ingredients:
            return "/ingredients"
        case .addToCart(let productId):
            return "/addtocart/" + productId.toString
        case .cart:
            return "/cart"
        case .removeFromCart(let productId):
            return "/removefromcart/" + productId.toString
        }
        
    }
    
    var httpMethod : HttpMethod {
        switch self {
        case .products , .ingredients , .addToCart,  .cart , .removeFromCart:
            return HttpMethod.get
        case .products:
            return .post
        }
    }
    
}

enum HttpMethod: String {
    case get, post
}

extension Int {
    
    var toString: String {
        return String(self)
    }
}
