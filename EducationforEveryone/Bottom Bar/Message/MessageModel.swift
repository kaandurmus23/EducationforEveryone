//
//  Message Model.swift
//  EducationforEveryone
//
//  Created by Kaan on 23.05.2023.
//

import Foundation
import SwiftUI

struct MessageModel: Identifiable, Hashable {
    var id: Int
    var message: String
    var uidFromFirebase: String
    var messageFrom: String
    var messageTo: String
    var messageDate: Date
    var messageFromMe: Bool
    var messageFromName: String
    var messageToName: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: MessageModel, rhs: MessageModel) -> Bool {
        return lhs.id == rhs.id
    }
}
