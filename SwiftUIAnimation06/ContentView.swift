//
//  ContentView.swift
//  SwiftUIAnimation06
//
//  Created by gzonelee on 2023/03/19.
//

import SwiftUI

struct ContentView: View {
    @State var temperature: Int = 0
    @State var ratio: Double?
    @StateObject private var customTimer = CustomTimer(interval: 0.25, totalTime: 115)
    let values: [[Double]] = [
        [ 30, 78, 120, 30, 3.75 ],
        [ 90, 30, 180, 80, 4.75 ],
        [ 60, 98, 150, 75, 1.22 ],
    ]
    @State var value: [Double] = [0, 0, 0, 0, 0]
    var body: some View {
        VStack {
            NumberTransitionView(number: temperature, suffix: " °C")
                .font(.title)
                .bold()
            TimerView(customTimer: customTimer)
            Spacer()
            HStack {
                Spacer()
                Spacer()
                PopupSelectionButton(currentValue: $ratio, values: [1.0, 1.5, 2, 2.5, 3, 4, 5])
                Spacer()
            }
            AnalogTimerView(status: customTimer.timerState, timerEndTime: customTimer.endDate(), timer: customTimer)
            AnimatedRadarChart(
                time: value[0],
                temperature: value[1],
                amountWater: value[2],
                amountTea: value[3],
                rating: value[4]
            )
            .frame(width: 100, height: 100)
            HStack {
                Button {
                    withAnimation {
                        value = values[0]
                    }
                } label: {
                    Text("1")
                }
                Button {
                    withAnimation {
                        value = values[1]
                    }
                } label: {
                    Text("2")
                }
                Button {
                    withAnimation {
                        value = values[2]
                    }
                } label: {
                    Text("3")
                }
            }
        }
        .padding()
        .onAppear {
            withAnimation {
                temperature = 85
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
