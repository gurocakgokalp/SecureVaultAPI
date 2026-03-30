//
//  VaultItem.swift
//  BackendSvapi
//
//  Created by Gökalp Gürocak on 30.03.2026.
//
import Fluent
import Vapor

final class VaultItem: Model, Content, @unchecked Sendable {
    static let schema = "vault_items"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "encrypted_blob")
    var encryptedBlob: String

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Field(key: "access_token")
    var accessToken: String

    init() {}

    init(id: UUID? = nil, encryptedBlob: String) {
        self.id = id
        self.encryptedBlob = encryptedBlob
        self.accessToken = UUID().uuidString
    }
}
