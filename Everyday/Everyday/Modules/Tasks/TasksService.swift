//
//  FirebaseService.swift
//  Everyday
//
//  Created by Михаил on 15.11.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum NetworkActionType {
    case add, remove, edit
}

class TaskService {
    
    static let shared = TaskService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func updateWith(task: Task, actionType: NetworkActionType, completion: @escaping (NetworkError?) -> Void) {
        getTasks { [self] result in
            switch result {
            case .success:
                switch actionType {
                case .add:
                    print("kek")
                    
                case .remove:
                    completion(deleteTask(taskReference: task.taskReference))
                    
                case .edit:
                    print("lol")
                }
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func deleteTask(taskReference: DocumentReference) -> NetworkError? {
        guard let userUID = Auth.auth().currentUser?.uid else {
            return .invalidUser
        }
        
        db.collection("user")
            .document(userUID)
            .updateData([
                "task_id": FieldValue.arrayRemove([taskReference])
            ])
        
        taskReference.delete()
        
        return nil
    }
    
    func getTasks(completion: @escaping (Result<[Task], NetworkError>) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            completion(.failure(.invalidUser))
            return
        }
        
        db.collection("user")
            .document(userUID)
            .getDocument { snapshot, error in
                guard error == nil else {
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
                
                guard let tasksUIDs = snapshotData["task_id"] as? [DocumentReference] else {
                    completion(.failure(.invalidData))
                    return
                }
                
                var tasks: [Task] = []
                let group = DispatchGroup()
                
                for taskReference in tasksUIDs {
                    group.enter()
                    taskReference.getDocument { document, error in
                        defer {
                            group.leave()
                        }
                        
                        guard error == nil else {
                            completion(.failure(.unableToComplete))
                            return
                        }
                        
                        guard let document = document,
                              let taskDocumentData = document.data(),
                              let startTimestamp = taskDocumentData["date_begin"] as? Timestamp,
                              let endTimestamp = taskDocumentData["date_end"] as? Timestamp,
                              let title = taskDocumentData["title"] as? String,
                              let priority = taskDocumentData["priority"] as? Int else {
                            completion(.failure(.invalidData))
                            return
                        }
                        
                        let startTime = startTimestamp.dateValue()
                        let endTime = endTimestamp.dateValue()
                        let taskName = title
                        let taskPriority = priority
                        
                        tasks.append(.init(taskReference: taskReference,
                                           startTime: startTime,
                                           endTime: endTime,
                                           taskName: taskName,
                                           taskPriority: taskPriority))
                    }
                }
                
                group.notify(queue: .main) {
                    completion(.success(tasks))
                }
            }
    }
}
