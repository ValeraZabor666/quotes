//
//  Models.swift
//  Yand
//
//  Created by Mac on 02.03.2021.
//

import Foundation

struct QuoteInfo: Decodable {
    var regularMarketPrice: Double
    var currency: String
    var shortName: String
    var symbol: String
    var regularMarketChange: Double
    var regularMarketChangePercent: Double
}

struct QuoteHistory: Decodable {
    var items: [String : Item]
}

struct Item: Decodable {
    var date: String
    var high: Double
    var open: Double
    var low: Double
    var close: Double
}

struct MoreInfo: Decodable {
    var country: String
    var state: String
    var city: String
    var address1: String
    var phone: String
    var website: String
    var industry: String
    var longBusinessSummary: String
}
