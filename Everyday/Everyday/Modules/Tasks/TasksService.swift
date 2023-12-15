//
//  FirebaseService.swift
//  Everyday
//
//  Created by Михаил on 15.11.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class TaskService {
    
    static let shared = TaskService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func fetchUserData(completion: @escaping (Result<UserTask, NetworkError>) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            completion(.failure(.invalidUser))
            return
        }
        
        db.collection("user")
            .document(userUID)
            .getDocument { snapshot, error in
                if error != nil {
                    completion(.failure(.unableToComplete))
                    return
                }
                
                guard let snapshot = snapshot else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                guard let snapshotData = snapshot.data() else {
                    completion(.failure(.invalidData))
                    return
                }
                if let username = snapshotData["username"] as? String,
                   let email = snapshotData["email"] as? String,
                   let taskUID = snapshotData["task_id"] as? [DocumentReference] {
                    let user = UserTask(username: username, email: email, userUID: userUID, taskUID: taskUID)
                    completion(.success(user))
                } else {
                    completion(.failure(.invalidData))
                }
            }
    }
}
