import Foundation
import SwiftUI
import Firebase
import Combine

class ChatStore: ObservableObject {
    var firebaseid: String
    let db = Firestore.firestore()
    var chatArray: [MessageModel] = []
    var objectWillChange = PassthroughSubject<[MessageModel], Never>()
    
    init(firebaseid: String) {
        self.firebaseid = firebaseid
        
        db.collection("Chats").whereField("chatUserFrom", isEqualTo: firebaseid)
            .addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("Error fetching chat documents: \(error.localizedDescription)")
                    return
                }
                
                self.chatArray.removeAll(keepingCapacity: false)
                
                for document in snapshot!.documents {
                    let chatUidFromFirebase = document.documentID
                    
                    if let chatMessage = document.get("message") as? String,
                        let messageFrom = document.get("chatUserFrom") as? String,
                        let messageTo = document.get("chatUserTo") as? String,
                        let dateString = document.get("date") as? String,
                        let dateFromFB = self.dateFromString(dateString: dateString) {
                        
                        self.fetchUsername(for: messageFrom) { (messageFromName) in
                            guard let messageFromName = messageFromName else { return }
                            
                            self.fetchUsername(for: messageTo) { (messageToName) in
                                guard let messageToName = messageToName else { return }
                                let currentIndex = self.chatArray.last?.id
                                let createdChat = MessageModel(id: (currentIndex ?? -1) + 1,
                                                               message: chatMessage,
                                                               uidFromFirebase: chatUidFromFirebase,
                                                               messageFrom: messageFrom,
                                                               messageTo: messageTo,
                                                               messageDate: dateFromFB,
                                                               messageFromMe: true,
                                                               messageFromName: messageFromName,
                                                               messageToName: messageToName)
                                
                                self.chatArray.append(createdChat)
                                self.objectWillChange.send(self.chatArray)
                            }
                        }
                    }
                }
            }
        
        db.collection("Chats").whereField("chatUserTo", isEqualTo: firebaseid)
            .addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("Error fetching chat documents: \(error.localizedDescription)")
                    return
                }
                
                for document in snapshot!.documents {
                    let chatUidFromFirebase = document.documentID
                    
                    if let chatMessage = document.get("message") as? String,
                        let messageFrom = document.get("chatUserFrom") as? String,
                        let messageTo = document.get("chatUserTo") as? String,
                        let dateString = document.get("date") as? String,
                        let dateFromFB = self.dateFromString(dateString: dateString) {
                        
                        self.fetchUsername(for: messageFrom) { (messageFromName) in
                            guard let messageFromName = messageFromName else { return }
                            
                            self.fetchUsername(for: messageTo) { (messageToName) in
                                guard let messageToName = messageToName else { return }
                                let currentIndex = self.chatArray.last?.id
                                let createdChat = MessageModel(id: (currentIndex ?? -1) + 1,
                                                               message: chatMessage,
                                                               uidFromFirebase: chatUidFromFirebase,
                                                               messageFrom: messageFrom,
                                                               messageTo: messageTo,
                                                               messageDate: dateFromFB,
                                                               messageFromMe: false,
                                                               messageFromName: messageFromName,
                                                               messageToName: messageToName)
                                
                                self.chatArray.append(createdChat)
                                self.objectWillChange.send(self.chatArray)
                            }
                        }
                    }
                }
            }
    }
    
    // Function to fetch username
    private func fetchUsername(for uid: String, completion: @escaping (String?) -> Void) {
        db.collection("Users").whereField("useruidfromfirebase", isEqualTo: uid).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching user documents: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let document = querySnapshot?.documents.first {
                let username = document.get("username") as? String
                completion(username)
            } else {
                print("User document does not exist")
                completion(nil)
            }
        }
    }
    
    // Function to convert date string to Date object
    private func dateFromString(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"
        return dateFormatter.date(from: dateString)
    }
}
