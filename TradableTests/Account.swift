//
//  Account.swift
//  TradableTests
//
//  Created by 1amageek on 2018/04/09.
//  Copyright © 2018年 Stamp Inc. All rights reserved.
//

import Foundation
import Pring

extension Test {

    @objcMembers
    final class Account: Object, AccountProtocol {
   
        typealias Transaction = Test.Transaction

        dynamic var country: String = "jp"

        dynamic var isRejected: Bool = false

        dynamic var isSigned: Bool = false

        dynamic var commissionRatio: Double = 0.0

        dynamic var balance: Balance = Balance()

        dynamic var transactions: NestedCollection<Transaction> = []
    }
}
