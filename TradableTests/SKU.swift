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

        var selledBy: Relation<Test.User> = .init()

        var createdBy: Relation<Test.User> = .init()

        var product: Relation<Test.Product> = .init()

        dynamic var currency: Currency = .JPY

        dynamic var price: Double = 0

        dynamic var name: String = ""

        dynamic var inventory: Inventory = Inventory(type: .finite, value: nil, quantity: 0)

//        dynamic var stockType: StockType = .finite
//
//        dynamic var stockQuantity: Int = 0
//
//        dynamic var stockValue: StockValue = .limited

        dynamic var isPublished: Bool = false

        dynamic var isActived: Bool = false

        override func encode(_ key: String, value: Any?) -> Any? {
            if key == "inventory" {
                return self.inventory.encode()
            }
            return nil
        }

        override func decode(_ key: String, value: Any?) -> Bool {
            if key == "inventory" {
                self.inventory = Inventory(data: value as! [String: Any])!
                return true
            }
            return false
        }
    }
}
