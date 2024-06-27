//
//  Home.swift
//  FocusTimerApp
//
//  Created by GOURAVM on 19/08/22.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var model : TimerModel
    var body: some View {
        VStack{
            Text("Focus Timer")
                .font(.title2.bold())
                .foregroundColor(.white)
            GeometryReader { proxy in
                
                VStack(spacing:15) {
                    ZStack{
                        Circle()
                            .fill(.purple.opacity(0.03))
                            .padding(-40)
                        Circle()
                            .trim(from: 0, to: model.progress)
                            .stroke(Color(.purple),lineWidth:5)
                            .blur(radius: 15)
                            .padding(-2)
                        Circle()
                            .fill(Color(.background))
                        Circle()
                            .trim(from: 0, to: model.progress)
                            .stroke(Color(.purple).opacity(0.7),lineWidth: 10)
                        GeometryReader { proxy in
                            let size = proxy.size
                            Circle()
                                .fill(Color(.purple))
                                .frame(width: 30, height: 30)
                                .overlay {
                                    Circle()
                                        .fill(.white)
                                        .padding(5)
                                    
                                }
                                .frame(width: size.width, height: size.height, alignment: .center)
                                .offset(x: size.height/2)
                                .rotationEffect(.init(degrees: model.progress * 360))
                                .opacity(model.totalSeconds == 0 ? 0 : 1)
                        }
                        Text(model.timerStringValue)
                            .font(.system(size:45,weight:.light))
                            .rotationEffect(.init(degrees: 90))
                            .animation(.none, value: model.progress)
                        
                    }
                    .padding(60)
                    .frame(height:proxy.size.width)
                    .rotationEffect(.init(degrees: -90))
                    
                    .animation(.easeInOut, value: model.progress)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    
                    Button {
                        
                        if model.isStarted {
                            model.stopTimer()
                            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        }
                        else {
                            model.addNewTimer = true
                        }
                    } label: {
                        Image(systemName: !model.isStarted ? "timer": "stop.fill")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80, alignment: .center)
                            .background {
                                Circle()
                                    .fill(Color(.purple))
                            }
                            .shadow(color: Color(.purple), radius: 8, x: 0, y: 0)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .padding()
        .background {
            Color(.background).ignoresSafeArea()
        }
        .overlay(content: {
            ZStack {
                Color.black.opacity(model.addNewTimer ? 0.25 : 0)
                    .onTapGesture {
                        model.addNewTimer = false
                        
                        model.hour = 0
                        model.minute = 0
                        model.seconds = 0
                    }
                NewTimerView()
                    .frame(maxHeight:.infinity,alignment: .bottom)
                    .offset(y: model.addNewTimer ? 0 : 400)
            }
            .animation(.easeInOut, value: model.addNewTimer)
        })
        
        .preferredColorScheme(.dark)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            if model.isStarted{
                model.updateTimer()
            }
        }
        .alert("Congratulations You did it!!", isPresented: $model.isFinished) {
            Button("Start New",role:.cancel) {
                model.stopTimer()
                model.addNewTimer = true
                
            }
            Button("Close",role:.destructive) {
                model.stopTimer()
            }
        }
    }
    
    @ViewBuilder
    func NewTimerView()->some View {
        VStack(spacing:15) {
            Text("Add New Timer")
                .font(.title2.bold())
                .foregroundColor(.white)
                .padding(.top,10)
            
            
            HStack(spacing:15) {
                Text("\(model.hour) hr")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal,20)
                    .padding(.vertical,12)
                    .background {
                        Capsule()
                            .fill(.white.opacity(0.07))
                    }
                    .contextMenu  {
                        Print("pressed")
                        ContextMenuOptions(maxVal: 12, hint: "hr") { value in
                            model.hour = value
                            
                        }
                    }
                
                Text("\(model.minute) min")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal,20)
                    .padding(.vertical,12)
                    .background {
                        Capsule()
                            .fill(.white.opacity(0.07))
                    }
                    .contextMenu  {
                        ContextMenuOptions(maxVal: 60, hint: "min") { value in
                            model.minute = value
                        }
                    }
                
                Text("\(model.seconds) sec")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal,20)
                    .padding(.vertical,12)
                    .background {
                        Capsule()
                            .fill(.white.opacity(0.07))
                    }
                    .contextMenu  {
                        ContextMenuOptions(maxVal: 60, hint: "sec") { value in
                            model.seconds = value
                        }
                    }
                
            }
            .padding(.top,20)
            
            Button {
                model.startTimer()
            } label: {
                Text("Save")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .padding(.horizontal,100)
                    .background {
                        Capsule()
                            .fill(Color(.purple))
                    }
            }
            .disabled(model.seconds == 0 && model.hour == 0 && model.minute == 0)
            .opacity(model.seconds == 0 && model.hour == 0 && model.minute == 0 ? 0.5 : 1)
            .padding(.top)
        }
        .padding()
        .frame(maxWidth:.infinity)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(.background))
                .ignoresSafeArea()
        }
    }
    @ViewBuilder
    func ContextMenuOptions(maxVal:Int,hint:String,onClick:@escaping(Int)->())-> some View {
        ForEach(1...maxVal,id:\.self) { value in
            Button("\(value) \(hint)") {
                onClick(value)
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TimerModel())
    }
}
