//
//  CounterView.swift
//  EducationforEveryone
//
//  Created by Kaan on 22.05.2023.
//

import SwiftUI

struct CounterView: View {
    let targetDates = [
        Calendar.current.date(from: DateComponents(year: 2023, month: 6, day: 17))!,
        Calendar.current.date(from: DateComponents(year: 2023, month: 6, day: 4))!
    ]
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                ForEach(targetDates, id: \.self) { targetDate in
                    if targetDate == targetDates[0] {
                        CountdownView(targetDate: targetDate, title: "YKS")
                    } else {
                        CountdownView(targetDate: targetDate, title: "LGS")
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct CountdownView: View {
    let targetDate: Date
    let title: String
    
    @State private var countdownText = ""
    @State private var timer: Timer?
    
    var body: some View {
        VStack(spacing: 10) {
            Text("\(title) Sayacı")
                .font(.title)
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.2))
                .foregroundColor(.blue)
                .cornerRadius(10)
            
            Text("\(countdownText)")
                .font(.title)
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.2))
                .foregroundColor(.blue)
                .cornerRadius(10)
        }
        .onAppear {
            startTimer()
        }
        .padding(.horizontal)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            let currentDate = Date()
            let calendar = Calendar.current
            
            let components = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: targetDate)
            
            let days = components.day ?? 0
            let hours = components.hour ?? 0
            let minutes = components.minute ?? 0
            let seconds = components.second ?? 0
            
            countdownText = "\(days) gün \(hours) saat \(minutes) dakika \(seconds) saniye"
            
            if currentDate >= targetDate {
                timer.invalidate()
            }
        }
    }
}

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView()
    }
}
