//
//  VaultController.swift
//  BackendSvapi
//
//  Created by Gökalp Gürocak on 30.03.2026.
//
import Fluent
import Vapor

struct VaultController: RouteCollection {
    func boot(routes: any Vapor.RoutesBuilder) throws {
        let vault = routes.grouped("vault")
        vault.post("store", use: store)
        vault.get(":id", use: retrieve)
        vault.delete(":id", use: delete)
    }
    
    
    func store(req: Request) async throws -> VaultItem {
        let input = try req.content.decode(StoreRequest.self)
        let item = VaultItem(encryptedBlob: input.blob)
        try await item.save(on: req.db)
        req.logger.info("Blob stored", metadata: ["id": .string(item.id!.uuidString)])
        return item
    }
    
    func retrieve(req: Request) async throws -> VaultItem {
        guard let item = try await VaultItem.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try req.verifyAccess(for: item)
        
        req.logger.info("Blob retrieved", metadata: ["id" : .string(item.id!.uuidString)])
        return item
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let item = try await VaultItem.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try req.verifyAccess(for: item)
        
        try await item.delete(on: req.db)
        req.logger.info("Blob deleted", metadata: ["id" : .string(item.id!.uuidString)])
        return .noContent
    }
}

