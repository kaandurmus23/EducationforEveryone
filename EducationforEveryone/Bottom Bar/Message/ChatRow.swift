//
//  ChatRow.swift
//  EducationforEveryone
//
//  Created by Kaan on 24.05.2023.
//

import SwiftUI

struct ChatRow: View {
    var text: String
    var isCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isCurrentUser {
                Spacer()
            }
            
            Text(text)
                .padding(8)
                .background(isCurrentUser ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)
            
            if !isCurrentUser {
                Spacer()
            }
        }
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatRow(text: "deneme", isCurrentUser: true)
    }
}
