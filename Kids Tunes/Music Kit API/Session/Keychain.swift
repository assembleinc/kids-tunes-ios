//
//  Keychain.swift
//  reDiscover
//
//  Created by Juan Karam on 6/24/18.
//  Copyright © 2018 Assemble. All rights reserved.
//

import Foundation

public class Keychain {
    private let keychainServiceKey = "com.kidz-tunez.keychain"

    enum KeychainError: Error {
        case runtimeError(String)
    }

    private func query(forKey key: String) -> [String: Any] {
        return [
            kSecClass as String : kSecClassGenericPassword as String,
            kSecAttrService as String : keychainServiceKey,
            kSecAttrAccount as String : key,
            kSecAttrAccessible as String : kSecAttrAccessibleAfterFirstUnlock as String
        ]
    }

    func set<T>(_ value: T, key: String) throws -> Void where T:Codable {
        var query = self.query(forKey: key)
        let data = [
            kSecValueData as String : try JSONEncoder().encode(value),
            kSecAttrAccessible as String : kSecAttrAccessibleAfterFirstUnlock
        ] as [String : Any]

        var status: OSStatus
        if let _ : T? = try getValue(forKey: key) {
            status = SecItemUpdate(query as CFDictionary, data as CFDictionary)
        } else {
            query.merge(data) { (_, new) in new }
            status = SecItemAdd(query as CFDictionary, nil)
        }

        guard status == errSecSuccess else {
            throw KeychainError.runtimeError("Unable to store value with status: \(status)")
        }
    }

    func getValue<T>(forKey key: String) throws -> T? where T:Codable {
        var query = self.query(forKey: key)
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        var data: AnyObject?
        let status: OSStatus = withUnsafeMutablePointer(to: &data) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        var value : T? = nil
        switch status {
        case errSecItemNotFound:
            value = nil
        case errSecSuccess:
            value = try JSONDecoder().decode(T.self, from: data as! Data)
        default:
            throw KeychainError.runtimeError("Unable to retrieve value with status: \(status)")
        }
        return value
    }

    public func deleteValue(forKey key: String) throws -> Void {
        let query = self.query(forKey: key)
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else {
            throw KeychainError.runtimeError("Unable to delete value with status: \(status)")
        }
    }
}
