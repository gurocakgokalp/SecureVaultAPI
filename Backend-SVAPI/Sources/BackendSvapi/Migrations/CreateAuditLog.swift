//
//  CreateAuditLog.swift
//  BackendSvapi
//
//  Created by Gökalp Gürocak on 30.03.2026.
//
import Fluent

struct CreateAuditLog: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("audit_logs")
            .id()
            .field("action", .string, .required)
            .field("item_id", .string, .required)
            .field("created_at", .datetime)
            .field("success", .bool)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("audit_logs").delete()
    }
}
