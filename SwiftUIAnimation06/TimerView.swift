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
    @StateObject private var customTimer = CustomTimer(interval: 0.25, totalTime: 115)
    @State var animateTimer: Bool = false
    @State var animatePause: Bool = false
    var angularGradient: AngularGradient {
        AngularGradient(colors: [.red, .blue, .green, .red],
                        center: .center,
                        angle: .degrees(animateTimer == true ? 360 : 0)
        )
    }
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
            TimerDigitsView(digits: customTimer.digits)
        }
        .onChange(of: playState, perform: { newValue in
            switch newValue {
            case .play:
                animatePause = false
                withAnimation(.linear(duration: 1)
                    .repeatForever(autoreverses: false)
                ) {
                    animateTimer = true
                }
            case .pause:
                animateTimer = false
                withAnimation(.easeInOut(duration: 0.5)
                    .repeatForever()
                ) {
                    animatePause = true
                }
                break
            case .stop:
                animatePause = false
                animateTimer = false
                break
            }
        })
        .padding(20)
        .padding(.horizontal, 40)
        .overlay {
            switch customTimer.timerState {
            case .play:
                RoundedRectangle(cornerRadius: 10)
                    .stroke(angularGradient, lineWidth: 10)
            case .pause:
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.blue.opacity(animatePause ? 0.2 : 1.0), lineWidth: 10)
            default:
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.green, lineWidth: 5)
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
