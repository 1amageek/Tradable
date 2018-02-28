//
//  Tradable.swift
//  Tradable
//
//  Created by 1amageek on 2018/02/25.
//  Copyright © 2018年 Stamp Inc. All rights reserved.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore
import Pring

public protocol UserProtocol: Document {

}

public protocol AddressProtocol: Document {

}

public protocol Tradable {
    associatedtype Product: ProductProtocol
    associatedtype Order: OrderProtocol
    associatedtype Person: UserProtocol
    var name: String { get set }
    var isAvailabled: Bool { get set }
    var products: ReferenceCollection<Product> { get }
    var skus: ReferenceCollection<Product.SKU> { get }
    var orders: ReferenceCollection<Order> { get }
}

public protocol AssetProtocol: Document {
    associatedtype Person: UserProtocol
    associatedtype SKU: SKUProtocol
    var createdBy: Relation<Person> { get set }
    var photo: File? { get set }
    var movie: File? { get set }
}

public protocol ProductProtocol: Document {
    associatedtype SKU: SKUProtocol
    associatedtype Person: UserProtocol
    associatedtype Asset: AssetProtocol
    var name: String { get set }
    var detail: String { get set }
    var seller: Relation<Person> { get set }
    var createdBy: Relation<Person> { get set }
    var skus: ReferenceCollection<SKU> { get }
    var assets: ReferenceCollection<Asset> { get }
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
        product.seller.set(Person(id: self.id, value: [:]))
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

public protocol SKUProtocol: Document {
    associatedtype Person: UserProtocol
    associatedtype Product: ProductProtocol
    var seller: Relation<Person> { get set }
    var createdBy: Relation<Person> { get set }
    var currency: Currency { get set }
    var product: Relation<Product> { get set }
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
    associatedtype SKU: SKUProtocol
    associatedtype Order: OrderProtocol
    associatedtype Person: UserProtocol
    var order: Relation<Order> { get set }
    var buyer: Relation<Person> { get set }
    var seller: Relation<Person> { get set }
    var type: OrderItemType { get set }    // OrderItemType
    var sku: Relation<SKU> { get }
    var quantity: Int { get set }
    var amount: Double { get set }
    var desc: String? { get set }
}

public protocol OrderProtocol: Document {
    associatedtype OrderItem: OrderItemProtocol
    associatedtype Person: UserProtocol
    associatedtype Address: AddressProtocol
    var parentID: String? { get set }
    var buyer: Relation<Person> { get set }
    var seller: Relation<Person> { get set }
    var shippingTo: Address? { get set }
    var paidAt: Date? { get set }
    var expirationDate: Date { get set }
    var currency: Currency { get set }
    var amount: Double { get set }
    var items: ReferenceCollection<OrderItem> { get set }
}
