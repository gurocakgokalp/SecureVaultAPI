//
//  VerifyAccess.swift
//  BackendSvapi
//
//  Created by Gökalp Gürocak on 30.03.2026.
//
import Vapor
import Fluent
import CVaporBcrypt

extension Request {
    func verifyAccess(for item: VaultItem) async throws {
        guard let bearer = self.headers.bearerAuthorization,
              try Bcrypt.verify(bearer.token, created: item.accessToken) else {
            
            try await AuditLog(action: "unauthorized", itemId: self.parameters.get("id") ?? "unknown", success: false).save(on: self.db)
            
            if let ipAdress = self.remoteAddress?.ipAddress {
                await BruteForceProtector.shared.recordFailure(for: ipAdress)
            }
            throw Abort(.unauthorized)
        }
    }
}

