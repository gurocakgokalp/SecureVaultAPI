//
//  AuditLog.swift
//  BackendSvapi
//
//  Created by Gökalp Gürocak on 30.03.2026.
//
import Fluent
import Vapor

final class AuditLog: Model, Content, @unchecked Sendable {
    static let schema = "audit_logs"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "action")
    var action: String
    
    @Field(key: "item_id")
    var itemId: String
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Field(key: "success")
    var success: Bool
    
    init() {}
    
    init(id: UUID? = nil, action: String, itemId: String, createdAt: Date? = nil, success: Bool) {
        self.id = id
        self.action = action
        self.itemId = itemId
        self.createdAt = createdAt
        self.success = success
    }
}


