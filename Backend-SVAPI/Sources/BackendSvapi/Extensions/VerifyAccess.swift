//
//  VerifyAccess.swift
//  BackendSvapi
//
//  Created by Gökalp Gürocak on 30.03.2026.
//
import Vapor
import Fluent

extension Request {
    func verifyAccess(for item: VaultItem) async throws {
        guard let bearer = self.headers.bearerAuthorization else {
            try await AuditLog(action: "unauthorized", itemId: self.parameters.get("id") ?? "unknown", success: false).save(on: self.db)
            throw Abort(.unauthorized)
        }
        
        guard item.accessToken == bearer.token else {
            try await AuditLog(action: "unauthorized", itemId: self.parameters.get("id") ?? "unknown", success: false).save(on: self.db)
            throw Abort(.unauthorized)
        }
    }
}

