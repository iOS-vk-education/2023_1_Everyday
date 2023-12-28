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
//
//  class StorageService {
//    public static let shared = StorageService()
//    private init() {}
//
//
//
//    func upload(photo: UIImage, complection: @escaping (Result<URL, Error>) -> Void) {
//        guard let userUID = Auth.auth().currentUser?.uid else {
//            return
//        }
//
//        let reference = Storage.storage().reference().child("avatars").child(userUID)
//
//        guard let imageData = photo.jpegData(compressionQuality: 0.4) else { return }
//
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
//        reference.putData(imageData, metadata: metadata) { (metadata, error) in
//            guard let metadata = metadata else {
//                complection(.failure(error!))
//                return
//            }
//            reference.downloadURL { (url, error) in
//                guard let url = url else {
//                    complection(.failure(error!))
//                    return
//            }
//                complection(.success(url))
//        }
//    }
//  }

//  final class StorageManager {
//    public static let shared = StorageManager()
//    private init() {}
//
//    private let storage = Storage.storage().reference()
//
//    func saveImage(data: Data, url: String) async throws {
//        let meta = StorageMetadata()
//        meta.contentType = "image/jpeg"
//
//        let path = "\(url).jpeg"
//        let returnedMetaData = try await storage.child(path).putDataAsync(data, metadata: meta)
//
//        guard let returnedPath = returnedMetaData.path, let returnedName = returnedMetaData.name else {
//            throw URLError(.badServerResponse)
//    }
//  }
//  }
//    final class StorageManager {
//        public static let shared = StorageManager()
//        private init() {}
//
//        private let storage = Storage.storage().reference()
//
//        func saveImage(data: Data) async throws -> (path: String, name: String) {
//            let meta = StorageMetadata()
//            meta.contentType = "image/jpeg"
//
//            let path = "\(UUID().uuidString).jpeg"
//            let returnedMetaData = try await storage.child(path).putDataAsync(data, metadata: meta)
//
//            guard let returnedPath = returnedMetaData.path, let returnedName = returnedMetaData.name else {
//                throw URLError(.badServerResponse)
//            }
//
//            return (returnedPath, returnedName)
//        }
//    }
