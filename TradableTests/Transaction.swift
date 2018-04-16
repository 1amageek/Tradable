//
//  Transaction.swift
//  TradableTests
//
//  Created by 1amageek on 2018/04/09.
//  Copyright © 2018年 Stamp Inc. All rights reserved.
//

import Foundation
import Pring

extension Test {

    @objcMembers
    class Transaction: Object, TransactionProtocol {

        dynamic var type: TransactionType = .payment

        dynamic var currency: Currency = .JPY

        dynamic var amount: Int = 0

        dynamic var fee: Int = 0

        dynamic var net: Int = 0

        dynamic var order: String?

        dynamic var transfer: String?

        dynamic var payout: String?
    }
}
