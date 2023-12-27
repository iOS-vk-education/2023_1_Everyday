//
//  TagService.swift
//  Everyday
//
//  Created by Михаил on 27.12.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class TagService {
    public static let shared = TagService()
    private init() {}
    
    public func fetchTag(completion: @escaping (TagModel?, Error?) -> Void) {
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
                   let tag = snapshotData["tag"] as? [String] {
                    let user = TagModel(tag: tag)
                    completion(user, nil)
                }
            }
    }
    
    public func addTag(_ newTag: String, completion: @escaping (Error?) -> Void) {
            guard let userUID = Auth.auth().currentUser?.uid else {
                return
            }
            
            let db = Firestore.firestore()
            let userRef = db.collection("user").document(userUID)
            
            userRef.updateData([
                "tag": FieldValue.arrayUnion([newTag])
            ]) { error in
                completion(error)
            }
        }
}
