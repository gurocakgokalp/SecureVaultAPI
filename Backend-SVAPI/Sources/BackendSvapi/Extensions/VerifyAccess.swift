//
//  VerifyAccess.swift
//  BackendSvapi
//
//  Created by Gökalp Gürocak on 30.03.2026.
//
import Vapor
import Fluent

extension Request {
    func verifyAccess(for item: VaultItem) throws {
        guard let bearer = self.headers.bearerAuthorization else {
            throw Abort(.unauthorized)
        }
        
        guard item.accessToken == bearer.token else {
            throw Abort(.unauthorized)
        }
    }
}

