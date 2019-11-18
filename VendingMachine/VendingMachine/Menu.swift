//
//  UserMenu.swift
//  VendingMachine
//
//  Created by 이진영 on 2019/10/28.
//  Copyright © 2019 JK. All rights reserved.
//

import Foundation

protocol Menu: CustomStringConvertible {
    var description: String { get }
}

enum UserMenu: Int, CaseIterable, Menu {
    case insertMoney = 1
    case purchaseBeverage
    
    var description: String {
        switch self {
        case .insertMoney:
            return "\(rawValue). 금액 추가"
        case .purchaseBeverage:
            return "\(rawValue). 음료 구매"
        }
    }
}

enum FailMessage: Menu {
    case invalidInputMessage
    case unableToPurchaseMessage
    
    var description: String {
        switch self {
        case .invalidInputMessage:
            return "잘못된 입력"
        case .unableToPurchaseMessage:
            return "상품 구매 불가"
        }
    }
}
