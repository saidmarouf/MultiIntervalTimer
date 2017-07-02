//: Playground - noun: a place where people can play

import Foundation

public class MultiIntervalTimer {

    /// the full duration (in seconds) where the the timer could span
    private var fullDuration: TimeInterval
    /// the intervals at wich the timer will fire. each interval represents a fraction of the `fullDuration`.
    /// an interval must be >= 0.0 and <= 1.0
    private var intervals: [Double] = []
    private var timers: [Int : Timer] = [:]

    public init(intervals: [Double], fullDuration: TimeInterval) {
        self.intervals = intervals
        self.fullDuration = fullDuration
    }

    public func fire(intervalBlock: @escaping (Double, Int) -> Void) {
        cancel()
        for intervalIndex in intervals.indices {
            let interval = intervals[intervalIndex]
            guard (0.0...1.0).contains(interval) else { continue }
            let intervalInSeconds = interval * fullDuration
            let timer = Timer.scheduledTimer(withTimeInterval: intervalInSeconds, repeats: false) { [weak self] timer in
                intervalBlock(interval, intervalIndex)
                self?.timers[intervalIndex] = nil
            }
            cacheTimer(timer, at: intervalIndex)
        }
    }

    private func cacheTimer(_ timer: Timer, at index: Int) {
        if timer.isValid {
            timers[index] = timer
        }
    }

    public func cancel() {
        for timer in timers.values where timer.isValid {
            timer.invalidate()
        }
        timers.removeAll()
    }

}

private extension Double {

    func toMicroSeconds() -> TimeInterval {
        return self * 1_000_000
    }

}
