//
//  RateLimiter.swift
//  BackendSvapi
//
//  Created by Gökalp Gürocak on 1.04.2026.
//
import Vapor

actor RateLimiter {
    static let shared = RateLimiter()
    let logger = Logger(label: "rate.limiter")
    
    private var clients: [String: ClientRateState] = [:]
    private let maxRequests = 10
    private let timeWindowInSeconds: TimeInterval = 60
    
    private init() {
        Task {
            await startCacheCleaning()
        }
    }
    
    // Date().timeIntervalSince(client.firstRequestTime) = Date().timeIntervalSince1970 - client.firstRequestTime.timeIntervalSince1970
    func checkLimit(for ip: String) async throws {
        if var client = clients[ip] {
            if client.requestCount < maxRequests && Date().timeIntervalSince(client.firstRequestTime) <= timeWindowInSeconds {
                client.requestCount += 1
                clients[ip] = client
            } else if Date().timeIntervalSince(client.firstRequestTime) > timeWindowInSeconds {
                client.firstRequestTime = Date()
                client.requestCount = 1
                clients[ip] = client
            } else {
                throw Abort(.tooManyRequests)
            }
        } else {
            clients.updateValue(ClientRateState(requestCount: 1, firstRequestTime: Date()), forKey: ip)
        }
    }
    
    func startCacheCleaning() {
        Task {
            while !Task.isCancelled {
                logger.info("Started Rate Limiter Cache Cleaner")
                cacheCleaner()
                try? await Task.sleep(for: .seconds(600))
            }
        }
    }
    
    func cacheCleaner() {
        clients = clients.filter { Date().timeIntervalSince($0.value.firstRequestTime) < 120 }
    }
    
}
