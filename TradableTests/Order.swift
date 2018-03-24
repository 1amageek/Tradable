//
//  Order.swift
//  TradableTests
//
//  Created by 1amageek on 2018/02/26.
//  Copyright © 2018年 Stamp Inc. All rights reserved.
//

import Foundation
import Pring

extension Test {

    @objcMembers
    class Order: Object, OrderProtocol {

        typealias OrderItem = Test.OrderItem

        typealias Person = Test.User

        typealias Address = Test.Address

        dynamic var parentID: String?

        dynamic var buyer: Relation<Test.User> = .init()

        dynamic var selledBy: Relation<Test.User> = .init()

        dynamic var shippingTo: Test.Address?

        dynamic var paidAt: Date?

        dynamic var expirationDate: Date = Date()

        dynamic var currency: Currency = .JPY

        dynamic var amount: Double = 0

        dynamic var status: OrderStatus = .created

        dynamic var items: NestedCollection<Test.OrderItem> = []

    }
}
