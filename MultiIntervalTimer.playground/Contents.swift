//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// initialize
let timer = MultiIntervalTimer(intervals: [0.2, 1.0], fullDuration: 5.0)

// fire and provide interval block
timer.fire(intervalBlock: { interval, intervalIndex in
    print("interval value:", interval, "interval index:", intervalIndex)
})

let second_timer = MultiIntervalTimer(intervals: [0.0, 0.5, 0.8, 1.0], fullDuration: 6.0)
second_timer.fire(intervalBlock: { interval, intervalIndex in
    print("second_timer interval value:", interval, "interval index:", intervalIndex)
})

let cancellationTime = DispatchTime.now() + DispatchTimeInterval.seconds(4)
DispatchQueue.main.asyncAfter(deadline: cancellationTime) {
    second_timer.cancel()
}

