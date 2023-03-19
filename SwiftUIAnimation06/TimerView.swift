//
//  TimerView.swift
//  SwiftUIAnimation06
//
//  Created by gzonelee on 2023/03/19.
//

import SwiftUI

struct TimerView: View {
    var playState: TimerState {
        return customTimer.timerState
    }
    @StateObject private var customTimer = CustomTimer(interval: 0.25, totalTime: 15)
    var angularGradient: AngularGradient {
        AngularGradient(colors: [.red, .blue, .green, .red],
                        center: .center,
                        angle: .degrees(animatingTime == true ? 360 : 0)
        )
    }
    @State var animatingTime = false
    var body: some View {
        VStack {
            Text("\(playState.rawValue)")
            HStack {
                Button {
                    if playState == .stop {
                        customTimer.start()
                    }
                    else if playState == .play {
                        customTimer.pause()
                    }
                    else if playState == .pause {
                        customTimer.start()
                    }
                } label: {
                    Image(systemName: playState == .play ? "pause.fill" : "play.fill")
                }
                .padding([.trailing], 20)
                Button {
                    customTimer.stop()
                } label: {
                    Image(systemName: "stop.fill")
                }
                .disabled(playState == .stop)
            }
            .padding(20)
            Text("\(customTimer.remainingTime, specifier: "%2f")")
                            .font(.largeTitle)
                            .padding()
        }
        .onChange(of: playState, perform: { newValue in
            switch newValue {
            case .play:
                withAnimation(.linear(duration: 1)
                    .repeatForever(autoreverses: false)
                ) {
                    animatingTime = true
                }
            case .pause:
                break
            case .stop:
                break
            }
        })
        .padding(20)
        .padding(.horizontal, 40)
        .overlay {
            if animatingTime == false {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.green, lineWidth: 5)
            }
            else {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(angularGradient, lineWidth: 10)
            }
            
        }
    }
    var remainingTime: Int {
        let r = Int(customTimer.remainingTime * 100)
        if r % 100 == 0 {
            return r / 100
        }
        return r / 100 + 1
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
