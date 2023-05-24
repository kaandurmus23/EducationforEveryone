//
//  CreateCourseView.swift
//  EducationforEveryone
//
//  Created by Kaan on 22.05.2023.
//

import SwiftUI
import Firebase

struct CreateCourseView: View {
    var firebaseuid : String
    let classes = ["6", "7", "8", "9", "10", "11", "12"]
    let courses = [
        "Matematik",
        "Fizik",
        "Kimya",
        "Biyoloji",
        "Tarih",
        "Coğrafya",
        "İngilizce",
        "Türkçe"
    ]
    let db = Firestore.firestore()
    @State private var selectedClasses = Set<String>()
    @State private var selectedCourses = Set<String>()
    @State private var selectedContactPersonCount = 1
    @State private var contactPersonCountOptions = Array(1...5)
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Kurs Oluşturma Görünümü")
                .font(.largeTitle)
            
            VStack(alignment: .leading) {
                Text("Sınıf Seçin:")
                    .font(.headline)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(classes, id: \.self) { classItem in
                            Button(action: {
                                if selectedClasses.contains(classItem) {
                                    selectedClasses.remove(classItem)
                                } else {
                                    selectedClasses.insert(classItem)
                                }
                            }) {
                                Text(classItem)
                                    .font(.subheadline)
                                    .foregroundColor(selectedClasses.contains(classItem) ? .white : .primary)
                                    .padding(10)
                                    .background(selectedClasses.contains(classItem) ? Color.blue : Color.gray.opacity(0.5))
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
            }
            .padding()
            
            VStack(alignment: .leading) {
                Text("Dersler Seçin:")
                    .font(.headline)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(courses, id: \.self) { course in
                            Button(action: {
                                if selectedCourses.contains(course) {
                                    selectedCourses.remove(course)
                                } else {
                                    selectedCourses.insert(course)
                                }
                            }) {
                                Text(course)
                                    .font(.subheadline)
                                    .foregroundColor(selectedCourses.contains(course) ? .white : .primary)
                                    .padding(10)
                                    .background(selectedCourses.contains(course) ? Color.blue : Color.gray.opacity(0.5))
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
            }
            .padding()
            
            VStack(alignment: .leading) {
                Text("İletişime Geçebilecek Kişi Sayısı:")
                    .font(.headline)
                
                Picker("", selection: $selectedContactPersonCount) {
                    ForEach(contactPersonCountOptions, id: \.self) { count in
                        Text("\(count)").tag(count)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding()
            
            // Kurs oluşturma içeriği ve kontrolleri
            // ...
            
            Button("Kaydet") {
                saveCourse()
                dismiss()
            }
            .font(.title)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            Button("Vazgeç"){
                dismiss()
            }
            .font(.title)
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
    
    private func saveCourse() {
        let courseDictionary: [String: Any] = [
            "firebaseuid" : firebaseuid,
            "classes": Array(selectedClasses),
            "courses": Array(selectedCourses),
            "contactPersonCount": selectedContactPersonCount
        ]
        db.collection("Course").addDocument(data: courseDictionary) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {

            }
        }
        // Kursu kaydetmek için burada gerekli işlemleri yapabilirsiniz
    }
    
    private func dismiss() {
        // Kurs oluşturma görünümünü kapat
        presentationMode.wrappedValue.dismiss()
    }
}

struct CreateCourseView_Previews: PreviewProvider {
    static var previews: some View {
        CreateCourseView(firebaseuid: "123")
    }
}
