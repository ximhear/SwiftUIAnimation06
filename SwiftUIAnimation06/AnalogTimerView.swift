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
    var status: TimerState
    var timerEndTime: Date?
    @ObservedObject var timer: CustomTimer
    var body: some View {
        VStack {
            ZStack {
                Canvas { context, size in
                    let timerSize = Int(min(size.width, size.height))
                    let xOffset = (size.width - Double(timerSize)) / 2.0
                    let yOffset = (size.height - Double(timerSize)) / 2.0
                    context.translateBy(x: xOffset, y: yOffset)
                    drawBorder(context: context, size: timerSize, borderWidth: 3)
                    context.translateBy(x: Double(timerSize / 2), y: Double(timerSize / 2))
                    context.rotate(by: .degrees(-90))
                    drawMinutes(context: context, size: timerSize)
                }
//                TimelineView(.animation(minimumInterval: 0.1, paused: status != .play)) { timeContext in
                TimelineView(.animation) { timeContext in
                    Canvas { context ,size in
                        let timerSize = Int(min(size.width, size.height))
                        context.translateBy(x: size.width / 2.0, y: size.height / 2.0)
                        context.rotate(by: .degrees(-90))
                        let remainingSeconds =  decimalTimeLeftAt(timeContext.date)
                        drawHands(context: context, size: timerSize, remainingTime: remainingSeconds)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            timerLength = timer.totalTime
        }
    }
    
    func decimalTimeLeftAt(_ current: Date) -> Double {
        switch status {
        case .stop:
            return timerLength
        case .play:
            guard let timerEndTime else {
                GZLogFunc(timerLength)
                return timerLength
            }
            
            let timerDifference = Calendar.current.dateComponents([.second, .nanosecond], from: current, to: timerEndTime)
            let seconds = Double(timerDifference.second ?? Int(timerLength))
            let nanoSeconds = Double(timerDifference.nanosecond ?? 0) / 1e9
            let remainingTime = seconds + nanoSeconds
            if remainingTime <= 0 {
            }
            GZLogFunc(remainingTime)
            return remainingTime
        case .pause:
            return Double(timeLeft ?? Int(timerLength))
        }
    }


    
    func createHandPath(length: Double, crossDistance: Double, middleDistance: Double, endDistance: Double, width: Double) -> Path {
        Path { path in
            path.move(to: .zero)
            let halfWidth = width / 2.0
            let crossLength = length * crossDistance
            let middleLength = length * middleDistance
            let halfWidthLength = length * halfWidth
            path.addCurve(to: .init(x: crossLength, y: 0),
                          control1: .init(x: crossLength, y: -halfWidthLength),
                          control2: .init(x: crossLength, y: -halfWidthLength))
            path.addCurve(to: .init(x: length * endDistance, y: 0),
                          control1: .init(x: middleDistance, y: halfWidthLength),
                          control2: .init(x: middleDistance, y: halfWidthLength))
            path.addCurve(to: .init(x: crossLength, y: 0),
                          control1: .init(x: middleDistance, y: -halfWidthLength),
                          control2: .init(x: middleDistance, y: -halfWidthLength))
            path.addCurve(to: .zero,
                          control1: .init(x: crossLength, y: halfWidthLength),
                          control2: .init(x: crossLength, y: halfWidthLength))
        }
    }
    
    func drawHands(context: GraphicsContext, size: Int, remainingTime: Double) {
        let length = Double(size / 2)
        let secondsLeft = remainingTime.truncatingRemainder(dividingBy: 60)
        let secondAngle = secondsLeft / 60 * 360
        let minuteColor: Color = .purple
        let secondColor: Color = .red
        let secondHandPath = createHandPath(length: length, crossDistance: 0.4, middleDistance: 0.6, endDistance: 0.7, width: 0.07)
        var sContext = context
        sContext.rotate(by: .degrees(secondAngle))
        sContext.fill(secondHandPath, with: .color(secondColor))
        sContext.stroke(secondHandPath, with: .color(secondColor), lineWidth: 3)
        
        let minutesLeft = remainingTime / 60
        let minuteAngle = minutesLeft / 10 * 360
        let minuteHandlePath = createHandPath(length: length, crossDistance: 0.3, middleDistance: 0.5, endDistance: 0.6, width: 0.1)
        var mContext = context
        mContext.rotate(by: .degrees(minuteAngle))
        mContext.fill(minuteHandlePath, with: .color(minuteColor))
        mContext.stroke(minuteHandlePath, with: .color(minuteColor), lineWidth: 5)
    }
    
    func drawBorder(context: GraphicsContext, size: Int, borderWidth: CGFloat) {
        let timerSize = CGSize(width: CGFloat(size) - borderWidth, height: CGFloat(size) - borderWidth)
        let outerPath = Path(ellipseIn: .init(origin: .init(x: borderWidth / 2.0, y: borderWidth / 2.0), size: timerSize))
        context.stroke(outerPath, with: .color(.black), lineWidth: borderWidth)
    }
    
    func drawMinutes(context: GraphicsContext, size: Int) {
        let center = Double(size / 2)
        for minute in 0..<10 {
            let minuteAngle = Double(minute) / 10 * 360.0
            let minuteTickPath = Path { path in
                path.move(to: .init(x: center, y: 0))
                path.addLine(to: .init(x: center * 0.9, y: 0))
                
            }
            var tickContext = context
            tickContext.rotate(by: .degrees(-minuteAngle))
            tickContext.stroke(minuteTickPath, with: .color(.black))
            
            let minuteString = "\(minute)"
            let textSize = minuteString.calculateTextSizeFor(font: UIFont.preferredFont(forTextStyle: .title2))
            let textRect = CGRect(origin: .init(x: -textSize.width / 2.0, y: -textSize.height / 2.0), size: textSize)
            let xShift = center * 0.8
            var stringContext = context
            stringContext.rotate(by: .degrees(minuteAngle))
            stringContext.translateBy(x: xShift, y: 0)
            stringContext.rotate(by: .degrees(-minuteAngle))
            stringContext.rotate(by: .degrees(90))
            let resolvedText = stringContext.resolve(Text(minuteString).font(.title2))
            stringContext.draw(resolvedText, in: textRect)
        }
    }
}

struct AnalogTimerView_Previews: PreviewProvider {
    @State static var timer = CustomTimer(interval: 1, totalTime: 100)
    static var previews: some View {
        AnalogTimerView(status: .stop, timer: timer)
            .frame(maxWidth: .infinity)
            .frame(height: 300)
    }
}

extension String {
  func calculateTextSizeFor(font: UIFont) -> CGSize {
    let string = (self as NSString)
    let attributes = [NSAttributedString.Key.font: font]
    let textSize = string.size(withAttributes: attributes)
    return textSize
  }
}
