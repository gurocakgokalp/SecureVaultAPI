//
//  BruteForceProtector.swift
//  BackendSvapi
//
//  Created by Gökalp Gürocak on 1.04.2026.
//
import Vapor

actor BruteForceProtector {
    static let shared = BruteForceProtector()
    private let logger = Logger(label: "brute.force.protector")
    
    private var clients: [String: ClientBruteForceState] = [:]
    
    private let maxFailure = 3
    private let timeWindowInSeconds: TimeInterval = 900
    
    private init() {
        Task {
            await startCacheCleaning()
        }
    }
    
    func recordFailure(for ip: String) {
        if var client = clients[ip] {
            client.failureCount += 1
            clients[ip] = client
        } else {
            clients.updateValue(ClientBruteForceState(failureCount: 1, firstRequestTime: Date()), forKey: ip)
        }
        checkFailureLimit(for: ip)
    }
    
    private func checkFailureLimit(for ip: String) {
        if var client = clients[ip] {
            if Date().timeIntervalSince(client.firstRequestTime) <= timeWindowInSeconds && client.failureCount > maxFailure {
                client.banUntil = Date().addingTimeInterval(900)
                clients[ip] = client
            }
        }
    }
    
    private func startCacheCleaning() {
        Task {
            while !Task.isCancelled {
                logger.info("Started Brute Force Cache Cleaner")
                cacheCleaner()
                try? await Task.sleep(for: .seconds(300))
            }
        }
    }
    
    private func cacheCleaner() {
        clients = clients.filter { Date().timeIntervalSince($0.value.firstRequestTime) < 1800 }
    }
    
    // zaten ilk girişiyse yani clients'te kayıtlı değilse sorun yoktur.
    func getClientBanStatus(for ip: String) -> Date? {
        if var client = clients[ip] {
            if let banDate = client.banUntil, Date() >= banDate {
                client.banUntil = nil
                client.failureCount = 0
                clients[ip] = client
                return nil
            }
            return client.banUntil
        } else {
            return nil
        }
        
    }
    
    func resetFailureCount(for ip: String) {
        clients.removeValue(forKey: ip)
    }
    
}

