//
//  ContentView.swift
//  VaultClient
//
//  Created by Gökalp Gürocak on 31.03.2026.
//

import SwiftUI

// Backend'deki Vapor modeline uygun, Codable destekli SwiftUI Modeli
struct VaultItem: Identifiable, Codable {
    var id: UUID
    var encryptedBlob: String
    var createdAt: Date?
    var accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case encryptedBlob = "encrypted_blob"
        case createdAt = "created_at"
        case accessToken = "access_token"
    }
    
    // UI'da göstermek için computed property'ler
    var displayId: String {
        id.uuidString.prefix(8).description
    }
    
    var shortToken: String {
        accessToken.prefix(12) + "..."
    }
    
    var shortBlob: String {
        // Blob çok uzun olabileceği için tabloda kısaltarak gösteriyoruz
        encryptedBlob.count > 15 ? encryptedBlob.prefix(15) + "..." : encryptedBlob
    }
}

struct ContentView: View {
    @State private var inputText: String = ""
    @State private var savedItems: [VaultItem] = []
    
    var body: some View {
        ZStack {
            // Arka Plan Blobu
            GeometryReader { proxy in
                MovingBlob(color: .red, proxy: proxy)
                    .opacity(0.15)
                    .blur(radius: 120)
            }
            .ignoresSafeArea()
            
            // Ana UI - Yan Yana Düzen (HStack)
            HStack(spacing: 24) {
                
                // --- SOL TARAF: Giriş ve Buton ---
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Enter your text")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        TextEditor(text: $inputText)
                            .font(.body)
                            .scrollContentBackground(.hidden)
                            .padding(12)
                            .background(.regularMaterial)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                            )
                            // TextEditor artık sol sütunu dolduracak şekilde esnek
                            .frame(maxHeight: .infinity)
                    }
                    
                    Button(action: {
                        storeAction()
                    }) {
                        Text("Store")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(.red)
                    .controlSize(.large)
                    .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .frame(width: 300) // Sol sütunun genişliğini sabitledik
                
                // --- SAĞ TARAF: Tablo ---
                VStack(alignment: .leading, spacing: 8) {
                    Text("Saved Vaults")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Table(savedItems) {
                        TableColumn("ID") { item in
                            Text(item.displayId)
                                .font(.system(.subheadline, design: .monospaced))
                                .foregroundColor(.secondary)
                        }
                        .width(min: 70, ideal: 80, max: .infinity)
                        
                        // Blob Sütunu Eklendi
                        TableColumn("Blob") { item in
                            Text(item.shortBlob)
                                .font(.system(.subheadline, design: .monospaced))
                        }
                        .width(min: 130, ideal: 150, max: .infinity)
                        
                        TableColumn("Token") { item in
                            Text(item.shortToken)
                                .font(.system(.body, design: .monospaced))
                                .fontWeight(.medium)
                        }
                        .width(min: 150, ideal: 180, max: .infinity)
                        
                        TableColumn("Date") { item in
                            Text(item.createdAt?.formatted(date: .abbreviated, time: .shortened) ?? "Just now")
                                .foregroundColor(.secondary)
                        }
                        .width(min: 100, ideal: 120, max: .infinity)
                    }
                    .scrollContentBackground(.hidden)
                    .background(.regularMaterial)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                    )
                }
                .frame(maxWidth: .infinity) // Sağ sütun kalan tüm alanı kaplar
            }
            .padding(24)
        }
        .frame(minWidth: 850, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity) // Yan yana düzen için pencere genişletildi
    }
    
    // Şifreleme ve API'ye gönderme işlemlerini yapacağın yer
    private func storeAction() {
        guard !inputText.isEmpty else { return }
        
        // TODO: Şifreleme (CryptoKit vs.) ve Vapor API'ye POST isteği atma mantığı
        let mockEncryptedBlob = "enc_" + UUID().uuidString.replacingOccurrences(of: "-", with: "").lowercased()
        
        // Simülasyon: API'den başarılı yanıt gelmiş gibi
        let newItem = VaultItem(
            id: UUID(),
            encryptedBlob: mockEncryptedBlob,
            createdAt: Date(),
            accessToken: UUID().uuidString
        )
        
        withAnimation(.spring()) {
            savedItems.insert(newItem, at: 0) // En üste ekler
            inputText = "" // Gönderildikten sonra alanı temizle
        }
    }
}

#Preview {
    ContentView()
}
