//
//  MessageView.swift
//  EducationforEveryone
//
//  Created by Kaan on 22.05.2023.
//

import SwiftUI
import Firebase

struct MessageListView: View {
    var firebaseid: String
    @ObservedObject var chatStore: ChatStore
    
    init(firebaseid: String) {
        self.firebaseid = firebaseid
        self.chatStore = ChatStore(firebaseid: firebaseid)
    }
    
    var body: some View {
        let dictionaryList: [[String: String]] = chatStore.chatArray.map { chat in
            if chat.messageFromMe {
                return ["isim": chat.messageToName, "firebaseid": chat.messageTo]
            } else {
                return ["isim": chat.messageFromName, "firebaseid": chat.messageFrom]
            }
        }
        
        let uniqueElements = Array(Set(dictionaryList))
        
        NavigationView {
            List(uniqueElements, id: \.self) { dictionary in
                NavigationLink(destination: ChatView(firebaseid: firebaseid, tofirebaseid: dictionary["firebaseid"] ?? "", chatStore: ChatStore(firebaseid: firebaseid))) {
                    Text(dictionary["isim"] ?? "")
                }
            }
            .navigationTitle("Mesaj Listesi")
        }
    }
}



struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView(firebaseid: "123")
    }
}
