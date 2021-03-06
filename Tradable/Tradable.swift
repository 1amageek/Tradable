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

// MARK: - User

public protocol UserProtocol: Document {
    associatedtype Order: OrderProtocol
    associatedtype TradeTransaction: TradeTransactionProtocol
    var isAvailabled: Bool { get set }
    var country: String { get set }
    var orders: NestedCollection<Order> { get set }
    var receivedOrders: NestedCollection<Order> { get set }
    var tradeTransactions: NestedCollection<TradeTransaction> { get set }
}

public protocol AddressProtocol: Document {

}

// MARK: - Account

public class Balance: NSObject {

    public private(set) var pending: [String: Int] = [:]

    public private(set) var available: [String: Int] = [:]

    public override init() {
        super.init()
    }

    public init?(data: [String: Any]) {
        guard let pending: [String: Int] = data["pending"] as? [String: Int] else {
            return nil
        }
        guard let available: [String: Int] = data["available"] as? [String: Int] else {
            return nil
        }
        self.pending = pending
        self.available = available
    }
}

public protocol AccountProtocol: Document {
    associatedtype BalanceTransaction: BalanceTransactionProtocol
    associatedtype PayoutRequest: PayoutProtocol
    var country: String { get set }
    var isRejected: Bool { get set }
    var isSigned: Bool { get set }
    var balance: Balance { get set }
    var balanceTransactions: NestedCollection<BalanceTransaction> { get }
    var payoutRequests: NestedCollection<PayoutRequest> { get }
}

public enum PayoutStatus: String {

    case none = "none"

    case requested = "requested"

    case rejected = "rejected"

    case completed = "completed"

    case cancelled = "cancelled"
}

public protocol PayoutProtocol: Document {
    associatedtype Person: AccountProtocol
    var currency: Currency { get set }
    var amount: Int { get set }
    var account: String { get set }
    var status: PayoutStatus { get set }
    var transactionResults: [Any] { get set }
    var isCancelled: Bool { get set }
}

// MARK: - TradeTransaction

public enum TradeTransactionType: String {
    case unknown = "unknown"
    case order = "order"
    case orderChange = "order_change"
    case orderCancel = "order_cancel"
    case storage = "storage"
    case retrieval = "retrieval"
}

public protocol TradeTransactionProtocol: Document {
    associatedtype SKU: SKUProtocol
    associatedtype Order: OrderProtocol
    associatedtype Person: UserProtocol
    var type: TradeTransactionType { get set }
    var selledBy: Relation<Person> { get set }
    var purchasedBy: Relation<Person> { get set }
    var order: Relation<Order> { get set }
    var product: DocumentReference? { get set }
    var sku: Relation<SKU> { get set }
    var inventoryStock: String? { get set }
    var item: DocumentReference? { get set }
}

// MARK: - BalanceTransaction

public enum BalanceTransactionType: String {
    case unknown = "unknown"
    case payment = "payment"
    case paymentRefund = "payment_refund"
    case transfer = "transfer"
    case transferRefund = "transfer_refund"
    case payout = "payout"
    case payoutCancel = "payout_cancel"
}

public protocol BalanceTransactionProtocol: Document {
    associatedtype SKU: SKUProtocol
    associatedtype Order: OrderProtocol
    associatedtype Person: UserProtocol
    var type: BalanceTransactionType { get set }
    var currency: Currency { get set }
    var amount: Int { get set }
    var from: Relation<Person> { get set }
    var to: Relation<Person> { get set }
    var order: Relation<Order> { get set }
    var transfer: String { get set }
    var payout: String { get set }
    var transactionResults: [Any] { get set }
}

// MARK: - Product

public protocol ProductProtocol: Document {
    associatedtype Person: UserProtocol
    associatedtype SKU: SKUProtocol
    var name: String { get set }
    var caption: String { get set }
    var selledBy: Relation<Person> { get set }
    var createdBy: Relation<Person> { get set }
    var isAvailabled: Bool { get set }
    var SKUs: NestedCollection<SKU> { get set }
}

public extension ProductProtocol where Self: Object, Person: Object {

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

    public init(type: StockType, value: StockValue) {
        self.type = type
        self.value = value
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

// MARK: - SKU

public protocol InventoryStockProtocol: Document {
    var isAvailabled: Bool { get set }
    var SKU: String { get set }
}

public protocol SKUProtocol: Document {
    associatedtype Person: UserProtocol
    associatedtype Product: ProductProtocol
    associatedtype InventoryStock: InventoryStockProtocol
    var selledBy: Relation<Person> { get set }
    var createdBy: Relation<Person> { get set }
    var currency: Currency { get set }
    var product: DocumentReference? { get set }
    var amount: Int { get set }
    var unitSales: Int { get set }
    var inventory: Inventory { get set }
    var isPublished: Bool { get set }
    var isAvailabled: Bool { get set }
    var numberOfFetch: Int { get set }
    var inventoryStocks: NestedCollection<InventoryStock> { get set }
}

// MARK: - Order

public enum OrderItemType: String {
    case sku        = "sku"
    case tax        = "tax"
    case shipping   = "shipping"
    case discount   = "discount"
}

public enum OrderItemStatus: String  {
    case none = "none"
    case ordered = "ordered"
    case changed = "changed"
    case canceled = "canceld"
}

public enum OrderTransferStatus: String {
    case none = "none"
    case rejected = "rejected"
    case transferred = "transferred"
    case cancelled = "cancelled"
    case transferFailure = "failure"
    case cancelFailure = "cancel_failure"
}

public enum OrderPaymentStatus: String {
    case none = "none"
    case rejected = "rejected"
    case authorized = "authorized"
    case paid = "paid"
    case cancelled = "cancelled"
    case paymentFailure = "failure"
    case cancelFailure = "cancel_failure"
}

public protocol OrderItemProtocol: Document {
    associatedtype SKU: SKUProtocol
    associatedtype Order: OrderProtocol
    associatedtype Person: UserProtocol
    var name: String? { get set }
    var thumbnailImage: File? { get set }
    var order: Relation<Order> { get set }
    var purchasedBy: Relation<Person> { get set }
    var createdBy: Relation<Person> { get set }
    var selledBy: Relation<Person> { get set }
    var type: OrderItemType { get set }
    var product: DocumentReference? { get set }
    var sku: Relation<SKU> { get set }
    var quantity: Int { get set }
    var currency: Currency { get set }
    var amount: Int { get set }
    var status: OrderItemStatus { get set }
}

public protocol OrderProtocol: Document {
    associatedtype OrderItem: OrderItemProtocol
    associatedtype Person: UserProtocol
    associatedtype Address: AddressProtocol
    var title: String? { get set }
    var assets: [File] { get set }
    var parentID: String? { get set }
    var purchasedBy: Relation<Person> { get set }
    var selledBy: Relation<Person> { get set }
    var shippingTo: Address? { get set }
    var transferredTo: Set<String> { get set }
    var paidAt: Timestamp? { get set }
    var expirationDate: Timestamp { get set }
    var currency: Currency { get set }
    var amount: Int { get set }
    var items: List<OrderItem> { get set }
    var paymentStatus: OrderPaymentStatus { get set }
    var transferStatus: OrderTransferStatus { get set }
    var transactionResults: [String: Any] { get set }
    var isCancelled: Bool { get set }
}

// MARK: - Item

public protocol ItemProtocol: Document {
    associatedtype SKU: SKUProtocol
    associatedtype Order: OrderProtocol
    associatedtype Person: UserProtocol
    var selledBy: Relation<Person> { get set }
    var order: Relation<Order> { get set }
    var product: DocumentReference? { get set }
    var sku: Relation<SKU> { get set }
    var isCancelled: Bool { get set }
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
