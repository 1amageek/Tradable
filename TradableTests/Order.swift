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

        var parentID: String?

        var buyer: Relation<Test.User> = .init()

        var seller: Relation<Test.User> = .init()

        var shippingTo: Test.Address?

        var paidAt: Date?

        var expirationDate: Date = Date()

        var currency: Currency = .JPY

        var amount: Double = 0

        var items: ReferenceCollection<Test.OrderItem> = []

    }
}
