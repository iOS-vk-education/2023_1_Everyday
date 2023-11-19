//
//  AuthService.swift
//  Everyday
//
//  Created by Михаил on 15.11.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

/// Class that provides connection with Firebase modules
class AuthService {
    public static let shared = AuthService()
    private init() {}
    
    /// A method to register user
    /// - Parameters:
    ///   - userRequest: user information
    ///   - completion: completion with 2 values
    ///   - Bool: wasRegistered - user was registered and added to firestore correctly
    ///   - Error?: an optional error if firebase provides once
    public func registerUser(with userRequest: SignUpModel, completion: @escaping(Bool, Error?) -> Void) {
        let username = userRequest.username
        let email = userRequest.email
        let password = userRequest.password
        let task = userRequest.task
        let event = userRequest.event
        let doneTask = userRequest.doneTask
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let resultUser = result?.user else {
                completion(false, nil)
                return
            }
            
            let db = Firestore.firestore()
            db.collection("user")
                .document(resultUser.uid)
                .setData([
                    "username": username,
                    "email": email,
                    "task_id": task,
                    "event_id": event,
                    "done_task": doneTask
                ]) { error in
                     if let error = error {
                        completion(false, error)
                        return
                     }
                    
                    completion(true, nil)
                }
        }
    }
    
    public func logIn(with userRequest: LoginModel, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(
            withEmail: userRequest.email,
            password: userRequest.password
        ) { _, error in
            if let error = error {
                completion(error)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    public func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
    public func forgotPassword(with email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
}
