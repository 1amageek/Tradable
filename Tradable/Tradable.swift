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
    var country: String { get set }
    var products: DataSource<Product>.Query { get }
    var orders: DataSource<Order>.Query { get }
    var orderings: DataSource<Order>.Query { get }
    var skus: DataSource<Product.SKU>.Query { get }
}

public class Balance: NSObject {

    public private(set) var accountsReceivable: [String: Int] = [:]

    public private(set) var available: [String: Int] = [:]

    public override init() {
        super.init()
    }

    public init?(data: [String: Any]) {
        guard let accountsReceivable: [String: Int] = data["accountsReceivable"] as? [String: Int] else {
            return nil
        }
        guard let available: [String: Int] = data["available"] as? [String: Int] else {
            return nil
        }
        self.accountsReceivable = accountsReceivable
        self.available = available
    }
}

public protocol AccountProtocol: Document {
    associatedtype Transaction: TransactionProtocol
    var country: String { get set }
    var isRejected: Bool { get set }
    var isSigned: Bool { get set }
    var commissionRatio: Double { get set } // 0 ~ 1
    var balance: Balance { get set }
    var transactions: NestedCollection<Transaction> { get }
}

public enum TransactionType: String {
    case payment         = "payment"
    case paymentRefund   = "payment_refund"
    case transfer        = "transfer"
    case transferRefund  = "transfer_refund"
    case payout          = "payout"
    case payoutCancel    = "payout_cancel"
}

public protocol TransactionProtocol: Document {
    var type: TransactionType { get set }
    var currency: Currency { get set }
    var amount: Int { get set }
    var fee: Int { get set }
    var net: Int { get set }
    var order: String? { get set }
    var transfer: String? { get set }
    var payout: String? { get set }
}

public protocol ProductProtocol: Document {
    associatedtype SKU: SKUProtocol
    associatedtype Person: UserProtocol
    var title: String { get set }
    var selledBy: Relation<Person> { get set }
    var createdBy: Relation<Person> { get set }
    var skus: NestedCollection<SKU> { get }
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

//public extension Tradable where Self: Object, Product: Object, Order: Object, Person == Product.Person {
//
//    public func add(product: Product, block: ((Error?) -> Void)?) {
//        guard let _ = Auth.auth().currentUser else {
//            print("[Tradable] error: Please perform user authentication.")
//            return
//        }
//        if product.skus.isEmpty {
//            print("[Tradable] error: SKU is required for the product.")
//            return
//        }
//        product.selledBy.set(Person(id: self.id, value: [:]))
//        
//        self.products.insert(product)
//        self.update(block)
//    }
//}

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

public class Inventory: NSObject {

    public var type: StockType
    public var value: StockValue?
    public var quantity: Int = 0

    public init(type: StockType, value: StockValue? = nil, quantity: Int) {
        self.type = type
        self.value = value
        self.quantity = quantity
    }

    public convenience override init() {
        self.init(type: .finite, quantity: 0)
    }

    public init?(data: [String: Any]) {
        guard let typeStr: String = data["type"] as? String, let type: StockType = StockType(rawValue: typeStr) else {
            return nil
        }
        guard let quantity: Int = data["quantity"] as? Int else {
            return nil
        }
        self.type = type
        self.quantity = quantity
        if let value: String = data["value"] as? String {
            self.value = StockValue(rawValue: value)
        }
    }

    public func encode() -> [String: Any] {
        return [
            "type": self.type.rawValue,
            "quantity": self.quantity,
            "value": self.value?.rawValue ?? NSNull()
        ]
    }
}

public protocol SKUProtocol: Document {
    associatedtype Person: UserProtocol
    associatedtype Product: ProductProtocol
    var selledBy: Relation<Person> { get set }
    var createdBy: Relation<Person> { get set }
    var currency: Currency { get set }
    var product: Relation<Product> { get set }
    var amount: Int { get set }
    var unitSales: Int { get set }
    var inventory: Inventory { get set }
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
    /// Immediately after the order made
    case created = "created"

    /// Inventory processing was done, but it was rejected
    case rejected = "rejected"

    /// Inventory processing was successful
    case received = "received"

    /// Customer payment succeeded, but we do not transfer funds to the account.
    case paid = "paid"

    /// Successful inventory processing but payment failed.
    case waitingForPayment = "waitingForPayment"

    /// Payment has been refunded.
    case refunded = "refunded"

    /// If payment was made, I failed in refunding.
    case waitingForRefund = "waitingForRefund"

    /// Everything including refunds was canceled. Inventory processing is not canceled
    case canceled = "canceled"

    /// It means that a payout has been made to the Account.
    case transferd = "transferd"

    /// It means that the transfer failed.
    case waitingForTransferrd = "waitingForTransferrd"
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
    var currency: Currency { get set }
    var amount: Int { get set }
}

public protocol OrderProtocol: Document {
    associatedtype OrderItem: OrderItemProtocol
    associatedtype Person: UserProtocol
    associatedtype Address: AddressProtocol
    var parentID: String? { get set }
    var buyer: Relation<Person> { get set }
    var selledBy: Relation<Person> { get set }
    var transferredTo: Set<String> { get set }
    var shippingTo: Address? { get set }
    var paidAt: Date? { get set }
    var expirationDate: Date { get set }
    var currency: Currency { get set }
    var amount: Int { get set }
    var fee: Int { get set }
    var net: Int { get set }
    var items: NestedCollection<OrderItem> { get set }
    var status: OrderStatus { get set }
}

public enum TradableErrorCode: String {
    case invalidArgument    = "invalidArgument"
    case lessMinimumAmount  = "lessMinimumAmount"
    case invalidCurrency    = "invalidCurrency"
    case invalidAmount      = "invalidAmount"
    case outOfStock         = "outOfStock"
    case invalidStatus      = "invalidStatus"
    case internalError      = "internal"
}


