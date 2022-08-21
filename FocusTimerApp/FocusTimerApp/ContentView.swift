//
//  ContentView.swift
//  FocusTimerApp
//
//  Created by GOURAVM on 19/08/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var timerModel :TimerModel
    var body: some View {
       Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TimerModel())
    }
}
