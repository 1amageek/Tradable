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

        var products: ReferenceCollection<Test.Product> = []

        var skus: ReferenceCollection<Test.SKU> = []

        var orders: ReferenceCollection<Test.Order> = []

    }
}
