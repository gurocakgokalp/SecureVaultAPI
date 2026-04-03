//
//  VaultController.swift
//  BackendSvapi
//
//  Created by Gökalp Gürocak on 30.03.2026.
//
import Fluent
import Vapor
import CVaporBcrypt

struct VaultController: RouteCollection {
    func boot(routes: any Vapor.RoutesBuilder) throws {
        let vault = routes.grouped("vault").grouped(BruteForceMiddleware())
        
        vault.post("store", use: store)
        vault.get(":id", use: retrieve)
        vault.delete(":id", use: delete)
    }
    
    
    func store(req: Request) async throws -> StoreResponse {
        let input = try req.content.decode(StoreRequest.self)
        
        let accessToken = UUID().uuidString
        let hashedToken = try Bcrypt.hash(accessToken)
        
        try input.validateSize()
        
        let item = VaultItem(encryptedBlob: input.blob, accessToken: hashedToken)
        try await item.save(on: req.db)
        req.logger.info("Blob stored", metadata: ["id": .string(item.id!.uuidString)])
        try await AuditLog(action: "store", itemId: item.id!.uuidString, success: true).save(on: req.db)
        return StoreResponse(id: item.id!.uuidString, accessToken: accessToken)
    }
    
    func retrieve(req: Request) async throws -> VaultItem {
        guard let item = try await VaultItem.find(req.parameters.get("id"), on: req.db) else {
            try await AuditLog(action: "retrieve", itemId: req.parameters.get("id") ?? "unknown", success: false).save(on: req.db)
            throw Abort(.notFound)
        }
        
        try await req.verifyAccess(for: item)
        if let ip = req.remoteAddress?.ipAddress {
            await BruteForceProtector.shared.resetFailureCount(for: ip)
        }
        try await AuditLog(action: "retrieve", itemId: item.id!.uuidString, success: true).save(on: req.db)
        req.logger.info("Blob retrieved", metadata: ["id" : .string(item.id!.uuidString)])
        return item
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let item = try await VaultItem.find(req.parameters.get("id"), on: req.db) else {
            try await AuditLog(action: "delete", itemId: req.parameters.get("id") ?? "unknown", success: false).save(on: req.db)
            throw Abort(.notFound)
        }
        try await req.verifyAccess(for: item)
        if let ip = req.remoteAddress?.ipAddress {
            await BruteForceProtector.shared.resetFailureCount(for: ip)
        }
        try await item.delete(on: req.db)
        req.logger.info("Blob deleted", metadata: ["id" : .string(item.id!.uuidString)])
        try await AuditLog(action: "delete", itemId: item.id!.uuidString, success: true).save(on: req.db)
        return .noContent
    }
}

