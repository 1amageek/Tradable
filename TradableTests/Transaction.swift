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

        dynamic var amount: Double = 0.0

        dynamic var fee: Double = 0.0

        dynamic var net: Double = 0.9

        dynamic var order: String?

        dynamic var transfer: String?

        dynamic var payout: String?
    }
}
