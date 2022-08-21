//
//  TimerModel.swift
//  FocusTimerApp
//
//  Created by GOURAVM on 19/08/22.
//

import SwiftUI

class TimerModel:NSObject, ObservableObject,UNUserNotificationCenterDelegate {
    @Published var progress: CGFloat = 1
    @Published var timerStringValue: String = "00:00"
    @Published var isStarted: Bool = false
    @Published var addNewTimer: Bool = false
    @Published var hour: Int = 0
    @Published var minute: Int = 0
    @Published var seconds: Int = 0
    @Published var isFinished = false
    @Published var totalSeconds: Int = 0
    @Published var staticTotalSeconds: Int = 0
    
    override init() {
        super.init()
        authorizeNotification()
    }
    
    func startTimer() {
        withAnimation(.easeInOut(duration: 0.25)) {
            isStarted = true
        }
        timerStringValue = "\(hour == 0 ? "" : "\(hour):")\(minute >= 10 ? "\(minute)":"0\(minute)"):\(seconds >= 10 ? "\(seconds)":"0\(seconds)")"
        
        totalSeconds = (hour * 3600) + (minute * 60) + seconds
        staticTotalSeconds = totalSeconds
        addNewTimer = false
        addNotification()
    }
    
    func stopTimer() {
        withAnimation {
            isStarted = false
            hour = 0
            minute = 0
            seconds = 0
            progress = 1
        }
        totalSeconds = 0
        staticTotalSeconds = 0
        timerStringValue = "00:00"
    }
    
    func updateTimer() {
        totalSeconds -= 1
        progress = CGFloat(totalSeconds) / CGFloat(staticTotalSeconds)
        progress = (progress < 0 ? 0 : progress)
        
        hour = totalSeconds / 3600
        minute = (totalSeconds / 60) % 60
        seconds = totalSeconds % 60
        
        timerStringValue = "\(hour == 0 ? "" : "\(hour):")\(minute >= 10 ? "\(minute)":"0\(minute)"):\(seconds >= 10 ? "\(seconds)":"0\(seconds)")"
        if hour == 0 && seconds == 0 && minute == 0 {
            isStarted = false
            print("finished")
            isFinished = true
        }
    }
    
    func authorizeNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound,.alert,.badge]) { isSuccess, error in
            
        }
        UNUserNotificationCenter.current().delegate = self
    }
    
    func addNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Focus Timer"
        content.subtitle = "Congratulations You did it!!"
        content.sound = UNNotificationSound.default
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(staticTotalSeconds), repeats: false))
        
        UNUserNotificationCenter.current().add(request)
    }
}
