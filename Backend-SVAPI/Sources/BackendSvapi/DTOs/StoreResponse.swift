//
//  StoreResponse.swift
//  BackendSvapi
//
//  Created by Gökalp Gürocak on 1.04.2026.
//

import Vapor

struct StoreResponse: Content {
    let id: String
    let accessToken: String
}
