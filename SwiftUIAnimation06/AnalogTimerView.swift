//
//  AnalogTimerView.swift
//  SwiftUIAnimation06
//
//  Created by gzonelee on 2023/03/26.
//

import SwiftUI

struct AnalogTimerView: View {
    @State var timerLength = 0.0
    @State var timeLeft: Int?
    @State var status: TimerState = .stop
    @State var timerEndTime: Date?
    @ObservedObject var timer: CustomTimer
    var body: some View {
        VStack {
            TimelineView(.periodic(from: .now, by: 1.0)) { context in
                Text(context.date.formatted(date: .omitted, time: .complete))
            }
        }
        .onAppear {
            timerLength = timer.totalTime
        }
    }
}

struct AnalogTimerView_Previews: PreviewProvider {
    @State static var timer = CustomTimer(interval: 1, totalTime: 100)
    static var previews: some View {
        AnalogTimerView(timer: timer)
    }
}
