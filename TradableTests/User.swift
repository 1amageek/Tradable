//
//  User.swift
//  TradableTests
//
//  Created by 1amageek on 2018/02/26.
//  Copyright © 2018年 Stamp Inc. All rights reserved.
//

import Foundation
import Pring

extension Test {

    @objcMembers
    class User: Object, UserProtocol, Tradable {

        typealias Product = Test.Product

        typealias Order = Test.Order

        typealias Person = Test.User

        dynamic var name: String = ""

        dynamic var isAvailabled: Bool = false

        dynamic var country: String = "jp"

        dynamic var orders: DataSource<Test.Order>.Query = Test.Order.query

        dynamic var orderings: DataSource<Test.Order>.Query = Test.Order.query

        dynamic var products: DataSource<Product>.Query = Product.query

        lazy var skus: DataSource<Test.SKU>.Query = Test.SKU.where("selledBy", isEqualTo: self.id)
    }
}
