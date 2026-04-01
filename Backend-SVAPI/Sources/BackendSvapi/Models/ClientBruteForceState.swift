//
//  ClientBruteForceState.swift
//  BackendSvapi
//
//  Created by Gökalp Gürocak on 1.04.2026.
//


import Vapor

struct ClientBruteForceState {
    var failureCount: Int
    var firstRequestTime: Date
    var banUntil: Date?
}
