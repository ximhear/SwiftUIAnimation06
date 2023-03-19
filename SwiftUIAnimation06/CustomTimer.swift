import SwiftUI
import Combine
import Foundation

enum TimerState: String {
    case play
    case pause
    case stop
}

class CustomTimer: ObservableObject {
    @Published var remainingTime: TimeInterval
    @Published var timerState: TimerState = .stop
    private var timerCancellable: AnyCancellable?
    private let interval: TimeInterval
private let totalTime: TimeInterval
    private var startTime: Date?

    init(interval: TimeInterval, totalTime: TimeInterval) {
        self.interval = interval
        self.totalTime = totalTime
        self.remainingTime = totalTime
    }

    func start() {
        if timerState == .play { return }
        if remainingTime == 0 {
            remainingTime = totalTime
            startTime = Date()
        }
        else {
            startTime = Date().addingTimeInterval(remainingTime - totalTime)
        }
        timerState = .play
        scheduleTimer(interval: interval)
    }

    func pause() {
        if remainingTime == 0 {
            timerState = .stop
        } else {
            timerState = .pause
        }
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    func stop(finished: Bool = false) {
        timerState = .stop
        timerCancellable?.cancel()
        timerCancellable = nil
        remainingTime = finished ? 0 : totalTime
    }

    private func scheduleTimer(interval: TimeInterval) {
        let publisher = Timer.publish(every: interval, on: .main, in: .common)
        timerCancellable = publisher.autoconnect().sink { [weak self] date in
            guard let self = self else { return }
            let elapsedTime = date.timeIntervalSince(self.startTime!)
            self.remainingTime = self.totalTime - elapsedTime
            if elapsedTime >= self.totalTime {
                self.stop(finished: true)
            }
        }
    }
    
    var digits: [Int] {
        let r = Int(remainingTime * 100)
        var seconds: Int
        if r % 100 == 0 {
            seconds = r / 100
        }
        else {
            seconds = r / 100 + 1
        }
        let minutes = seconds / 60
        seconds = seconds - minutes * 60
        return [minutes / 10, minutes % 10, seconds / 10, seconds % 10]
    }
}
