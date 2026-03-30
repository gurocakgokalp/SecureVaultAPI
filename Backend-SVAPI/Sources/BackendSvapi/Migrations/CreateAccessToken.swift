//
//  CreateAccessToken.swift
//  BackendSvapi
//
//  Created by Gökalp Gürocak on 30.03.2026.
//
import Fluent

struct CreateAccessToken: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("vault_items")
            .field("access_token", .string)
            .update()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("vault_items")
            .deleteField("access_token")
            .update()
    }
}

