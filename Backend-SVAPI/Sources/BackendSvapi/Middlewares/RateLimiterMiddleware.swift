//
//  RateLimiterMiddleware.swift
//  BackendSvapi
//
//  Created by Gökalp Gürocak on 1.04.2026.
//
import Vapor

struct RateLimiterMiddleware: AsyncMiddleware {
    func respond(to request: Vapor.Request, chainingTo next: any Vapor.AsyncResponder) async throws -> Vapor.Response {
        if let ipAddress = request.remoteAddress?.ipAddress {
            request.logger.info("Request from IP: \(ipAddress)")
            try await RateLimiter.shared.checkLimit(for: ipAddress)
        }
        return try await next.respond(to: request)
    }
}

