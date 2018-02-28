//
//  SKU.swift
//  TradableTests
//
//  Created by 1amageek on 2018/02/26.
//  Copyright © 2018年 Stamp Inc. All rights reserved.
//

import Foundation
import Pring

extension Test {

    @objcMembers
    class SKU: Object, SKUProtocol {

        typealias Product = Test.Product

        typealias Person = Test.User

        var seller: Relation<Test.User> = .init()

        var createdBy: Relation<Test.User> = .init()

        var product: Relation<Test.Product> = .init()

        dynamic var currency: Currency = .JPY

        dynamic var price: Double = 0

        dynamic var stockType: StockType = .finite

        dynamic var stockQuantity: Int = 0

        dynamic var stockValue: StockValue = .limited

        dynamic var isPublished: Bool = false

        dynamic var isActived: Bool = false
    }
}
