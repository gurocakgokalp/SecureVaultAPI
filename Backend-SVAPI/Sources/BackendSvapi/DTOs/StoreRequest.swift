//
//  StoreRequest.swift
//  BackendSvapi
//
//  Created by Gökalp Gürocak on 30.03.2026.
//
import Vapor

struct StoreRequest: Content {
    let blob: String
}
