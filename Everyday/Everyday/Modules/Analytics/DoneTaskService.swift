//
//  FirebaseService.swift
//  Everyday
//
//  Created by Михаил on 15.11.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class DoneTaskService {
    public static let shared = DoneTaskService()
    private init() {}
    
    public func fetchUser(completion: @escaping (User?, Error?) -> Void) {
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
                   let email = snapshotData["email"] as? String,
                   let doneTaskIds = snapshotData["done_task_id"] as? [DocumentReference] {
                    let user = User(username: username, email: email, userUID: userUID, doneTaskIds: doneTaskIds)
                    completion(user, nil)
                }
            }
    }
}
