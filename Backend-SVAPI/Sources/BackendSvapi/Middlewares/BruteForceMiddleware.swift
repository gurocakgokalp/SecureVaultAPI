//
//  BruteForceMiddleware.swift
//  BackendSvapi
//
//  Created by Gökalp Gürocak on 1.04.2026.
//
import Vapor

struct BruteForceMiddleware: AsyncMiddleware {
    func respond(to request: Vapor.Request, chainingTo next: any Vapor.AsyncResponder) async throws -> Vapor.Response {
        if let ipAddress = request.remoteAddress?.ipAddress {
            let banUntil = await BruteForceProtector.shared.getClientBanStatus(for: ipAddress)
            if banUntil != nil {
                throw Abort(.tooManyRequests, reason: "IP banned for 15 minutes.")
            }
        }
        
        return try await next.respond(to: request)
    }
}
