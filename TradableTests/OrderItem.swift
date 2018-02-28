//
//  OrderItem.swift
//  TradableTests
//
//  Created by 1amageek on 2018/02/26.
//  Copyright © 2018年 Stamp Inc. All rights reserved.
//

import Foundation
import Pring

extension Test {

    @objcMembers
    class OrderItem: Object, OrderItemProtocol {

        typealias SKU = Test.SKU

        typealias Order = Test.Order

        typealias Person = Test.User

        var order: Relation<Test.Order> = .init()

        var buyer: Relation<Test.User> = .init()

        var seller: Relation<Test.User> = .init()

        var type: OrderItemType = .sku

        var sku: Relation<Test.SKU> = .init()

        var quantity: Int = 0

        var amount: Double = 0

        var desc: String?

    }
}
