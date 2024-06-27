//
//  FocusTimerAppApp.swift
//  FocusTimerApp
//
//  Created by GOURAVM on 19/08/22.
//

import SwiftUI
import UserNotifications

@main
struct FocusTimerAppApp: App {
    
    @StateObject var timerModel: TimerModel = .init()
    
    @Environment(\.scenePhase) var phase
    @State var lastActiveTimeStamp : Date = Date()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delgate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timerModel)
        }
        .onChange(of: phase) { newValue in
            if timerModel.isStarted {
                if newValue == .background {
                    lastActiveTimeStamp = Date()
                }
                
                let currentTimeStampDiff = Date().timeIntervalSince(lastActiveTimeStamp)
                if newValue == .active {
                    timerModel.isStarted = false
                    timerModel.totalSeconds = 0
                    timerModel.isFinished = true
                }
                else {
                    timerModel.totalSeconds = Int(currentTimeStampDiff)
                }
            }
        }
    }
}

extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}


class AppDelegate:NSObject,UIApplicationDelegate,UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        if UIDevice.hasDynamicIsland {
            return [.sound]
        }
        else {
            return [.sound,.banner]
        }
    }
}

extension UIDevice {
    static var hasDynamicIsland: Bool {
        ["iPhone 14 Pro", "iPhone 14 Pro Max"].contains(current.name)
    }
}

