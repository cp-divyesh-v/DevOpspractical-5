//
//  TimerViewModel.swift
//  DevOpsPractical5
//
//  Created by Divyesh Vekariya on 23/03/24.
//

import Foundation
import SwiftUI
import Combine
import UserNotifications

class TimerViewModel: ObservableObject {
    @Published var hours: Int = 0
    @Published var minutes: Int = 0
    @Published var seconds: Int = 0
    @Published var isTimerRunning: Bool = false
    @Published var remainingTime: TimeInterval = 0
    @Published var elapsedTime: TimeInterval = 0
    @Published var showGif: Bool = false
    
    private var timer: AnyCancellable?

    init() {
        resetTimer()
    }

    func startTimer() {
        let totalSeconds = hours * 3600 + minutes * 60 + seconds
        remainingTime = TimeInterval(totalSeconds)

        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if self.isTimerRunning {
                    if self.remainingTime > 0 {
                        SoundManager.instance.stopSound()
                        self.remainingTime -= 1
                        self.elapsedTime += 1
                        
                        if self.remainingTime == 0 {
                            self.stopTimer()
                            SoundManager.instance.playSound()
                            self.showGif = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.showGif = false
                            }
                            self.showNotification()
                        }
                    }
                }
            }
        isTimerRunning = true
    }

    func stopTimer() {
        timer?.cancel()
        timer = nil
        isTimerRunning = false
    }

    func resetTimer() {
        stopTimer()
        hours = 0
        minutes = 0
        seconds = 0
        remainingTime = 0
        elapsedTime = 0
    }

    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func timeStringFromTimeInterval(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: interval) ?? "00:00:00"
    }
    
    func showNotification() {
        requestNotificationAuthorization()
        let content = UNMutableNotificationContent()
        content.title = "Time's Up!"
        content.subtitle = "The countdown timer has ended."
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification request: \(error.localizedDescription)")
            } else {
                print("Notification request added successfully.")
            }
        }
        resetTimer()
    }
}
