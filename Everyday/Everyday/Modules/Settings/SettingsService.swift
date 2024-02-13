//
//  SettingsService.swift
//  Everyday
//
//  Created by Yaz on 18.12.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class SettingsService {
    public static let shared = SettingsService()
    private init() {}
    
    public func updateUsername(username: String) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            return
        }

        let db = Firestore.firestore()

        let reference = db.collection("user").document(userUID)

        reference.updateData([
            "username": username
        ])
    }
    
    public func updateAvatarUrl(url: String) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            return
        }

        let db = Firestore.firestore()

        let reference = db.collection("user").document(userUID)

        reference.updateData([
            "avatarURL": url
        ])
    }
    public func fetchUser(completion: @escaping (ProfileModel?, Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            return
        }

        let db = Firestore.firestore()

        db.collection("user")
            .document(userUID)
            .getDocument { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }

                if let snapshot = snapshot,
                   let snapshotData = snapshot.data(),
                   let username = snapshotData["username"] as? String,
                   let avatar = snapshotData["avatarURL"] as? String {
                   let userProfile = ProfileModel(username: username, avatarURL: avatar)
                 completion(userProfile, nil)
                   let userSettings = SettingsModel(username: username, avatarURL: avatar)
                  completion(userProfile, nil)
                }
            }
    }
}

class ChangeEmailService {
    public static let shared = ChangeEmailService()
    private init() {}
    
    func changeEmail(newEmail: String) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()

        let reference = db.collection("user").document(userUID)

        reference.updateData([
            "email": newEmail
        ])
    }
}
