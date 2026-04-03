//
//  StoreRequest.swift
//  BackendSvapi
//
//  Created by Gökalp Gürocak on 30.03.2026.
//
import Vapor

struct StoreRequest: Content {
    let blob: String
    
    func validateSize() throws {
        let maxBytes = 256 * 1024
        
        guard blob.utf8.count <= maxBytes else {
            throw Abort(.payloadTooLarge, reason: "The encrypted blob exceeds the maximum allowed size of 256 KB.")
        }
    }
}
