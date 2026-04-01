//
//  ClientRateState.swift
//  BackendSvapi
//
//  Created by Gökalp Gürocak on 1.04.2026.
//
import Vapor

struct ClientRateState {
    var requestCount: Int
    var firstRequestTime: Date
}

