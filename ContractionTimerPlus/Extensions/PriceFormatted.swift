//
//  PriceFormatted.swift
//  ContractionTimerPlus
//
//  Created by ismail örkler on 28.02.2025.
//
import StoreKit

extension Product {
    var priceFormatted: String {
        return self.price.formatted(.currency(code: self.priceFormatStyle.currencyCode))
    }
}
