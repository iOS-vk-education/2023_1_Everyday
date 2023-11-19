//
//  SignUpRequest.swift
//  Everyday
//
//  Created by Михаил on 15.11.2023.
//

import Foundation
import FirebaseFirestore

struct SignUpModel {
    let username: String
    let email: String
    let password: String
    let task: [DocumentReference] = []
    let doneTask: [DocumentReference] = []
    let event: [DocumentReference] = []
}
