//
//  Asset.swift
//  TradableTests
//
//  Created by 1amageek on 2018/02/28.
//  Copyright © 2018年 Stamp Inc. All rights reserved.
//

import Foundation
import Pring

extension Test {

    @objcMembers
    class Asset: Object, AssetProtocol {

        typealias Person = Test.User

        typealias SKU = Test.SKU

        var createdBy: Relation<Person> = .init()

        dynamic var photo: File?

        dynamic var movie: File?
    }
}
