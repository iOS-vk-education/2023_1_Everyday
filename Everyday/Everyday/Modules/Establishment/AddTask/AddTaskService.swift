//
//  AddTaskService.swift
//  Everyday
//
//  Created by Михаил on 28.12.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AddTakService {
    public static let shared = AddTakService()
    private init() {}
    
    public func addTask(task: AddTaskModel, completion: @escaping (Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            return
        }

        let db = Firestore.firestore()
        let taskDocumentReference = db.collection("task").document()
        let taskData: [String: Any] = [
            "tag": task.tag,
            "date_begin": task.dateBegin,
            "date_end": task.dateEnd,
            "priority": task.priority,
            "subtask": task.subtask,
            "status": task.status,
            "description": task.description
        ]

        taskDocumentReference.setData(taskData) { error in
            if let error = error {
                completion(error)
                return
            }

            let userDocumentReference = db.collection("user").document(userUID)

            userDocumentReference.updateData([
                "task_id": FieldValue.arrayUnion([taskDocumentReference.documentID])
            ]) { error in
                completion(error)
            }
        }
    }
}
