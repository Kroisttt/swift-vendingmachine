//
//  Inventory.swift
//  VendingMachine
//
//  Created by 이진영 on 2019/10/28.
//  Copyright © 2019 JK. All rights reserved.
//

import Foundation

protocol Storable {
    mutating func addStock(_ product: Sellable)
    mutating func removeStock(_ product: Sellable)
    mutating func takeProduct(at index: Int) -> Sellable?
    func search(option: ProductStatus, balance: Money) -> [Sellable]
    func showInventory(form: (Int, String, Int, Int) -> ())
}

extension Storable {
    func search(option: ProductStatus, balance: Money = Money()) -> [Sellable] {
        return search(option: option, balance: balance)
    }
}

enum ProductStatus {
    case hot
    case expired
    case purchasable
    case all
}

struct BeverageInventory: Storable {
    private var stock: [SellEdible]
    
    init(stock: [SellEdible]) {
        self.stock = stock
    }
    
    private var stockCounter: [(product: Sellable, count: Int)] {
        var countResult = [ObjectIdentifier : Int]()
        
        stock.forEach { countResult[$0.objectID] = (countResult[$0.objectID] ?? 0) + 1 }
        
        let sortResult = countResult.sorted(by: <)
        
        var result: [(Sellable, Int)] = []
        
        sortResult.forEach { (objectID, count) in
            if let index = stock.firstIndex(where: { $0.objectID == objectID }) {
                result.append((stock[index], count))
            }
        }
        
        return result
    }
    
    mutating func addStock(_ product: Sellable) {
        if let edibleProduct = product as? SellEdible {
            stock.append(edibleProduct)
        }
    }
    
    mutating func removeStock(_ product: Sellable) {
        if let index = stock.firstIndex(where: { $0.objectID == product.objectID }) {
            stock.remove(at: index)
        }
    }
    
    mutating func takeProduct(at index: Int) -> Sellable? {
        let product = stockCounter[index - 1].product
        
        guard let index = stock.firstIndex(where: { $0.objectID == product.objectID }) else {
            return nil
        }
        
        return stock.remove(at: index)
    }
    
    func search(option: ProductStatus, balance: Money = Money()) -> [Sellable] {
        switch option {
        case .hot:
            return stock.filter { $0.isHot }
        case .expired:
            return stock.filter { !$0.isValidate }
        case .all:
            return stock
        case .purchasable:
            return stock.filter { $0.productPrice <= balance }
        }
    }
    
    func showInventory(form: (Int, String, Int, Int) -> ()) {
        for (index, stock) in stockCounter.enumerated() {
            form(index + 1, stock.product.productName, stock.product.productPrice, stock.count)
        }
    }
}
