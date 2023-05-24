import Foundation
import Firebase
import SwiftUI


class CourseStore: ObservableObject {
    let db = Firestore.firestore()
    @Published var courseArray: [CourseModel] = []
    
    init() {
        db.collection("Course").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self.courseArray.removeAll()
            
            var users: [String: String] = [:] // Kullanıcıların UID ve isim bilgisini saklamak için bir sözlük
            
            // Firebase'den kullanıcıları çekip sözlüğe atama
            self.db.collection("Users").getDocuments { (querySnapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                for document in querySnapshot!.documents {
                    guard let firebaseuid = document.get("useruidfromfirebase") as? String,
                          let name = document.get("username") as? String else {
                        continue
                    }
                    
                    users[firebaseuid] = name
                }
                
                // Course koleksiyonundan verileri çekme
                for document in snapshot!.documents {
                    guard let firebaseuid = document.get("firebaseuid") as? String,
                          let classes = document.get("classes") as? [String],
                          let contactPersonCount = document.get("contactPersonCount") as? Int,
                          let courses = document.get("courses") as? [String] else {
                        continue
                    }
                    
                    let name = users[firebaseuid] ?? ""
                    
                    let currentIndex = self.courseArray.last?.id ?? 0
                    let courseModel = CourseModel(id: currentIndex + 1, firebaseid: firebaseuid, name: name, classes: classes, courses: courses, contactCount: contactPersonCount)
                    self.courseArray.append(courseModel)
                }
                
                // Test amaçlı çıktı
                for x in self.courseArray {
                    print(x.name)
                    for y in x.courses {
                        print(y)
                    }
                }
            }
        }
    }
}




struct CourseModel: Identifiable {
    var id: Int
    var firebaseid: String
    var name: String
    var classes: [String]
    var courses: [String]
    var contactCount: Int
}
