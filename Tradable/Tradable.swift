//
//  Tradable.swift
//  Tradable
//
//  Created by 1amageek on 2018/02/25.
//  Copyright © 2018年 Stamp Inc. All rights reserved.
//

import Firebase
import FirebaseFirestore
import Pring

public protocol Tradable {
    associatedtype Product: ProductProtocol
    var name: String { get set }
    var isAvailabled: Bool { get set }
    var products: ReferenceCollection<Product> { get }
    var skus: ReferenceCollection<Product.SKU> { get }
}

public protocol ProductProtocol: Document {
    associatedtype SKU: SKUProtocol
    var name: String { get set }
    var detail: String { get set }
    var sellerID: String { get set }
    var createdByID: String { get set }
    var skus: ReferenceCollection<SKU> { get }
}

public enum StockType: String {
    case finite     = "finite"
    case bucket     = "bucket"
    case infinite   = "infinite"
}

public enum StockValue: String {
    case inStock    = "in_stock"
    case limited    = "limited"
    case outOfStock = "out_of_stock"
}

public protocol SKUProtocol: Document {
    var sellerID: String { get set }
    var createdByID: String { get set }
    var currency: Currency { get set }
    var price: Double { get set }
    var stockType: StockType { get set }
    var stockQuantity: Int { get set }
    var stockValue: StockValue { get set }
    var isPublished: Bool { get set }
    var isActived: Bool { get set }
}

public enum OrderItemType: String {
    case sku        = "sku"
    case tax        = "tax"
    case shipping   = "shipping"
    case discount   = "discount"
}

public protocol OrderItemProtocol: Document {
    var orderID: String { get set }
    var buyerID: String { get set }
    var sellerID: String { get set }
    var type: OrderItemType { get set }    // OrderItemType
    var skuID: String { get set }
    var quantity: Int { get set }
    var amount: Double { get set }
    var desc: String? { get set }
}

public protocol OrderProtocol: Document {
    associatedtype OrderItem: OrderItemProtocol
    var parentID: String? { get set }
    var buyerID: String { get set }
    var sellerID: String { get set }
    var paidAt: Date { get set }
    var expirationDate: Date { get set }
    var currency: Currency { get set }
    var amount: Double { get set }
    var items: ReferenceCollection<OrderItem> { get set }
}

