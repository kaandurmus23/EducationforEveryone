//
//  CourseRow.swift
//  EducationforEveryone
//
//  Created by Kaan on 22.05.2023.
//

import SwiftUI

struct CourseRow: View {
    var course: CourseModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(course.name)
                .font(.headline)
            Text("Classes: \(course.classes.joined(separator: ", "))")
                .font(.subheadline)
            Text("Courses: \(course.courses.joined(separator: ", "))")
                .font(.subheadline)
            Text("Contact Count: \(course.contactCount)")
                .font(.subheadline)
        }
    }
}

struct CourseRow_Previews: PreviewProvider {
    static var previews: some View {
        CourseRow(course: CourseModel(id: 1, firebaseid: "123", name: "John Doe", classes: ["10", "11"], courses: ["Math", "Physics"], contactCount: 2))
    }
}


