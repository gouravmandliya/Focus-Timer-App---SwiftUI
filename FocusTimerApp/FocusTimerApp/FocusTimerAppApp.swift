//
//  FocusTimerAppApp.swift
//  FocusTimerApp
//
//  Created by GOURAVM on 19/08/22.
//

import SwiftUI

@main
struct FocusTimerAppApp: App {
    
    @StateObject  var  timerModel :TimerModel = .init()
    
    @Environment(\.scenePhase) var phase
    @State var lastActiveTimeStamp : Date = Date()
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
