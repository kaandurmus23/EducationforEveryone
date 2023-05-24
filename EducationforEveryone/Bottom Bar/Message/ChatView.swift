//
//  ChatView.swift
//  EducationforEveryone
//
//  Created by Kaan on 23.05.2023.
//

import SwiftUI
import Firebase

struct ChatView: View {
    var firebaseid: String
    var tofirebaseid: String
    @ObservedObject var chatStore: ChatStore
    @State private var newMessage: String = ""
    let db = Firestore.firestore()
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(chatStore.chatArray.sorted(by: { $0.messageDate < $1.messageDate }).reversed()) { message in
                        if message.messageFrom == firebaseid && message.messageTo == tofirebaseid {
                            ChatRow(text: message.message, isCurrentUser: true)
                        } else if message.messageFrom == tofirebaseid && message.messageTo == firebaseid {
                            ChatRow(text: message.message, isCurrentUser: false)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
            
            HStack {
                TextField("Mesaj Giriniz", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: sendMessage) {
                    Text("Mesaj Gönder")
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)

    }
    
    func sendMessage() {
        let myChatDictionary: [String: Any] = [
            "chatUserFrom": firebaseid,
            "chatUserTo": tofirebaseid,
            "date": generateDate(),
            "message": self.newMessage
        ]
        
        db.collection("Chats").addDocument(data: myChatDictionary) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                self.newMessage = ""
            }
        }
    }
}


func generateDate() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"
    return formatter.string(from: Date())
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(firebaseid: "123", tofirebaseid: "12", chatStore: ChatStore(firebaseid: "123"))
    }
}
