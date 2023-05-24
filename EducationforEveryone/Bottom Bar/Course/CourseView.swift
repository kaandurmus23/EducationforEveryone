//
//  SwiftUIView.swift
//  EducationforEveryone
//
//  Created by Kaan on 22.05.2023.
//

import SwiftUI
import Firebase

struct CourseView: View {
    let db = Firestore.firestore()
    var firebaseuid: String
    @State private var isCreatingCourse = false
    @ObservedObject var courseStore = CourseStore()
    @State private var showAlert = false
    @State private var selectedCourse: CourseModel?
    
    var body: some View {
        NavigationView {
            VStack {
                List(courseStore.courseArray) { course in
                    Button(action: {
                        selectedCourse = course
                        showAlert = true
                    }) {
                        CourseRow(course: course)
                    }
                }
            }
            .navigationBarTitle("Kurs Listesi")
            .navigationBarItems(trailing:
                Button(action: {
                    isCreatingCourse = true
                }) {
                    Image(systemName: "plus")
                        .imageScale(.large)
                }
                .sheet(isPresented: $isCreatingCourse) {
                    CreateCourseView(firebaseuid: firebaseuid)
                }
            )
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("İletişime Geç"),
                    message: Text("Kurs ilanını veren kişiye mesaj atmak istiyor musunuz?"),
                    primaryButton: .default(Text("Mesaj Gönder")) {
                        if let selectedCourse = selectedCourse {
                            let courseFirebaseID = selectedCourse.firebaseid

                            db.collection("Course").whereField("firebaseuid", isEqualTo: courseFirebaseID).getDocuments { (snapshot, error) in
                                if let error = error {
                                    print("Error retrieving documents: \(error.localizedDescription)")
                                } else {
                                    guard let documents = snapshot?.documents else {
                                        print("No documents found.")
                                        return
                                    }
                                    var count = selectedCourse.contactCount - 1
                                    for document in documents {
                                        if selectedCourse.contactCount > 1{
                                            document.reference.updateData(["contactPersonCount" : count])
                                        }else{
                                            document.reference.delete()

                                        }
                                    }
                                    
                                    print("Documents deleted successfully.")
                                }
                            }
                            
                            let myChatDictionary: [String:Any] = [
                                "chatUserFrom": firebaseuid,
                                "chatUserTo": selectedCourse.firebaseid,
                                "date": generateDate(),
                                "message" : "Ders için başvuruda bulunmak istiyorum"
                            ]
                            db.collection("Chats").addDocument(data: myChatDictionary) { error in
                                if let error = error {
                                    print(error.localizedDescription)
                                } else {
                                    // Mesaj başarıyla kaydedildi
                                }
                            }
                        }
                    },
                    secondaryButton: .cancel(Text("İptal et")) {
                        // İptal Butonu
                    }
                )
            }
        }
    }

    func generateDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"
        return formatter.string(from: Date())
    }
}
