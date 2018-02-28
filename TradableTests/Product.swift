//
//  Product.swift
//  TradableTests
//
//  Created by 1amageek on 2018/02/28.
//  Copyright © 2018年 Stamp Inc. All rights reserved.
//

import Foundation
import Pring

extension Test {

    @objcMembers
    class Product: Object, ProductProtocol {

        typealias SKU = Test.SKU

        typealias Person = Test.User

        typealias Asset = Test.Asset

        dynamic var name: String = ""

        dynamic var detail: String = ""

        dynamic var seller: Relation<Test.User> = .init()

        dynamic var createdBy: Relation<Test.User> = .init()

        dynamic var skus: ReferenceCollection<Test.SKU> = []

        dynamic var assets: ReferenceCollection<Test.Asset> = .init()

    }
}
