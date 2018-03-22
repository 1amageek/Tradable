//
//  Tradable.swift
//  Tradable
//
//  Created by 1amageek on 2018/02/25.
//  Copyright © 2018年 Stamp Inc. All rights reserved.
//

import FirebaseFirestore
import FirebaseAuth
import Pring

public protocol UserProtocol: Document {

}

public protocol AddressProtocol: Document {

}

public protocol Tradable {
    associatedtype Product: ProductProtocol
    associatedtype Order: OrderProtocol
    associatedtype Person: UserProtocol
    var isAvailabled: Bool { get set }
    var products: ReferenceCollection<Product> { get }
    var skus: ReferenceCollection<Product.SKU> { get }
    var orders: ReferenceCollection<Order> { get }
}

public protocol ProductProtocol: Document {
    associatedtype SKU: SKUProtocol
    associatedtype Person: UserProtocol
    var title: String { get set }
    var selledBy: Relation<Person> { get set }
    var createdBy: Relation<Person> { get set }
    var skus: ReferenceCollection<SKU> { get }
}

public extension ProductProtocol where Self: Object, SKU: Object, Person: Object {

    public init() {
        self.init()
        guard let user: User = Auth.auth().currentUser else {
            print("[Tradable] error: Please perform user authentication.")
            return
        }
        self.createdBy.set(Person(id: user.uid, value: [:]))
    }

    public init(id: String) {
        self.init(id: id)
        guard let user: User = Auth.auth().currentUser else {
            print("[Tradable] error: Please perform user authentication.")
            return
        }
        self.createdBy.set(Person(id: user.uid, value: [:]))
    }
}

public extension Tradable where Self: Object, Product: Object, Order: Object, Person == Product.Person {

    public func add(product: Product, block: ((Error?) -> Void)?) {
        guard let _ = Auth.auth().currentUser else {
            print("[Tradable] error: Please perform user authentication.")
            return
        }
        if product.skus.isEmpty {
            print("[Tradable] error: SKU is required for the product.")
            return
        }
        product.selledBy.set(Person(id: self.id, value: [:]))
        product.skus.forEach { (sku) in
            self.skus.insert(sku)
        }
        self.products.insert(product)
        self.update(block)
    }
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

public struct Inventory {

    public var type: StockType
    public var value: StockValue?
    public var quantity: Int = 0

    public static func encode(_ key: String, value: Any?) -> [String: Any] {
        var endoedValue: [String: Any] = [:]
        if let inventory: Inventory = value as? Inventory {
            endoedValue["stockType"] = inventory.type.rawValue
            if let value: StockValue = inventory.value {
                endoedValue["stockValue"] = value.rawValue
            }
            endoedValue["quantity"] = inventory.quantity
        }
        return endoedValue
    }

    public static func decode(_ key: String, value: Any?) -> Inventory {
        let inventory: [String: Any] = value as! [String: Any]
        let type: String = inventory["stockType"] as! String
        let quantity: Int = inventory["quantity"] as! Int
        var decodeValue: Inventory = Inventory(type: StockType(rawValue: type)!,
                                               value: nil,
                                               quantity: quantity)
        if let value: String = inventory["value"] as? String {
            decodeValue.value = StockValue(rawValue: value)
        }
        return decodeValue
    }
}

public protocol SKUProtocol: Document {
    associatedtype Person: UserProtocol
    associatedtype Product: ProductProtocol
    var selledBy: Relation<Person> { get set }
    var createdBy: Relation<Person> { get set }
    var currency: Currency { get set }
    var product: Relation<Product> { get set }
    var name: String { get set }
    var price: Double { get set }
    var inventory: Inventory { get set }
//    var stockType: StockType { get set }
//    var stockQuantity: Int { get set }
//    var stockValue: StockValue { get set }
    var isPublished: Bool { get set }
    var isActived: Bool { get set }
}

public enum OrderItemType: String {
    case sku        = "sku"
    case tax        = "tax"
    case shipping   = "shipping"
    case discount   = "discount"
}

public enum OrderStatus: String {
    case unknown = "unknown"

    /// Immediately after the order made
    case created = "created"

    /// Inventory processing was done, but it was rejected
    case rejected = "rejected"

    /// Inventory processing was successful
    case received = "received"

    /// Payment was successful
    case paid = "paid"

    /// Successful inventory processing but payment failed.
    case waitingForPayment = "waitingForPayment"

    /// If payment was made, I failed in refunding.
    case waitingForRefund = "waitingForRefund"

    /// Everything including refunds was canceled. Inventory processing is not canceled
    case canceled = "canceled"
}

public protocol OrderItemProtocol: Document {
    associatedtype SKU: SKUProtocol
    associatedtype Order: OrderProtocol
    associatedtype Person: UserProtocol
    var order: Relation<Order> { get set }
    var buyer: Relation<Person> { get set }
    var selledBy: Relation<Person> { get set }
    var type: OrderItemType { get set }    // OrderItemType
    var sku: Relation<SKU> { get }
    var quantity: Int { get set }
    var amount: Double { get set }
}

public protocol OrderProtocol: Document {
    associatedtype OrderItem: OrderItemProtocol
    associatedtype Person: UserProtocol
    associatedtype Address: AddressProtocol
    var parentID: String? { get set }
    var buyer: Relation<Person> { get set }
    var selledBy: Relation<Person> { get set }
    var shippingTo: Address? { get set }
    var paidAt: Date? { get set }
    var expirationDate: Date { get set }
    var currency: Currency { get set }
    var amount: Double { get set }
    var items: NestedCollection<OrderItem> { get set }
    var status: OrderStatus { get set }
}
