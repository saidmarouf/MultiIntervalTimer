//: Playground - noun: a place where people can play

import Foundation

public class MultiIntervalTimer {

    /// the full duration (in seconds) that the the timer can span
    private var fullDuration: TimeInterval
    /// the intervals at wich the timer will fire. each interval represents a fraction of the `fullDuration`.
    /// an interval must be >= 0.0 and <= 1.0
    private var intervals: [Double] = []
    private var timers: [Int : Timer] = [:]

    public init(intervals: [Double], fullDuration: TimeInterval) {
        self.intervals = intervals
        self.fullDuration = fullDuration
    }

    /// fires the timer and executes `intervalBlock` at each specified interval
    public func fire(intervalBlock: @escaping (Double, Int) -> Void) {
        cancel()
        for intervalIndex in intervals.indices {
            let interval = intervals[intervalIndex]
            guard let intervalInSeconds = intervalInSeconds(for: interval) else { continue }
            let timer = Timer.scheduledTimer(withTimeInterval: intervalInSeconds, repeats: false) { [weak self] timer in
                intervalBlock(interval, intervalIndex)
                self?.timers[intervalIndex] = nil
            }
            cache(timer: timer, at: intervalIndex)
        }
    }

    private func intervalInSeconds(for interval: TimeInterval) -> TimeInterval? {
        guard (0.0...1.0).contains(interval) else { return nil }
        return interval * fullDuration
    }

    private func cache(timer: Timer, at index: Int) {
        if timer.isValid {
            timers[index] = timer
        }
    }

    /// cancels the timer including remaining intervals
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
