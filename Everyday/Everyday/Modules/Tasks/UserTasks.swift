//
//  User.swift
//  Everyday
//
//  Created by Михаил on 15.11.2023.
//

import Foundation
import FirebaseFirestore

struct UserTasks {
    let username: String
    let email: String
    let userUID: String
    let doneTaskIds: [DocumentReference]
}
