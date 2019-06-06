//
//  Session.swift
//  reDiscover
//
//  Created by Gabriel Sosa on 6/6/18.
//  Copyright © 2018 Assemble. All rights reserved.
//

import Foundation

public class Session {
    public static let current = Session()
    private var sessionKeyStore : SessionKeyStore?
    private let keychain = Keychain()
    private let sessionKeyStoreStorageKey = "com.kidzTunezKey.sessionKeyStore"

    private class SessionKeyStore : Codable {
        var secrets : [Constants.Keychain : String]
        init(secrets: [Constants.Keychain: String]) {
            self.secrets = secrets
        }
    }

    private init() {
        self.sessionKeyStore = try! keychain.getValue(forKey: sessionKeyStoreStorageKey) ?? nil
    }

    public var isAuthenticated : Bool {
        return self.sessionKeyStore != nil
    }

    public func beginSession(secrets: [Constants.Keychain: String]) throws -> Void {
        self.endSession()
        let sessionKeyStore = SessionKeyStore(secrets: secrets)
        try! keychain.set(sessionKeyStore, key: sessionKeyStoreStorageKey)
        self.sessionKeyStore = sessionKeyStore
        NotificationCenter.default.post(name: .sessionStatusChanged, object: self)
    }

    public func sessionSecret(forKey key: Constants.Keychain) -> String? {
        return self.sessionKeyStore?.secrets[key]
    }

    public func setSessionSecret(_ secret: String, forKey key: Constants.Keychain) throws {
        self.sessionKeyStore?.secrets[key] = secret
        try keychain.set(sessionKeyStore, key: sessionKeyStoreStorageKey)
    }

    public func endSession() {
        try? keychain.deleteValue(forKey: sessionKeyStoreStorageKey)
        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleIdentifier)
        }
        self.sessionKeyStore = nil
        NotificationCenter.default.post(name: .sessionStatusChanged, object: self)
    }
}
