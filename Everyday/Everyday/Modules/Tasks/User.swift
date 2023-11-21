//
//  User.swift
//  Everyday
//
//  Created by Михаил on 15.11.2023.
//

import Foundation
import FirebaseFirestore

struct User {
    let username: String
    let email: String
    let userUID: String
    let doneTaskIds: [DocumentReference] = []
}
