//
//  CreateVaultItem.swift
//  BackendSvapi
//
//  Created by Gökalp Gürocak on 30.03.2026.
//
import Fluent

struct CreateVaultItem: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("vault_items")
            .id()
            .field("encrypted_blob", .string, .required)
            .field("created_at", .datetime)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("vault_items").delete()
    }
}
