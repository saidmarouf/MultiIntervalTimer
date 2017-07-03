# MultiIntervalTimer
A Timer that fires at various custom interval values, rather than a single specified interval.

## Usage
1. Initialize a `MultiIntervalTimer` by specifiying passing two parameters:
    - `fullDuration`: the full duration (in seconds) the timer should span. This is needed to calculate the time to fire wach interval.
    - `intervals`: an array of intervals where each interval: `0.0 <= interval <= 1.0`. An interval represents a fraction of the `fullDuration`. Example: if `fullDuration == 3`, then an `interval == 0.5` means the timer would fire after `1.5` seconds.  
**Note: to fire the timer at the beginning and end of the `fullDuration` you must specify `0.0` and `1.0` as part of the intervals**

2. Trigger the timer by calling the `fire` function. You can pass an `intervalBlock` to the function. This block gets executed at each interval specified. The block provides you with the `interval` and the `intervalIndex`.

3. Cancel the timer if needed. To cancel an ongoing timer, call the `cancel` function.  
**Note: the timer invalidates automatically once all intervals are complete, or when the `fire` function is called again.**

## Examples

1. A timer that fires at the intervals `[0.2, 1.0]` over a `5.0` second `fullDuration`. This means the timer will fire after `1` second (= `0.2 * 5.0`) and after `5` seconds (= `1.0 * 5.0`).

```swift
// initialize
let timer = MultiIntervalTimer(intervals: [0.2, 1.0], fullDuration: 5.0)

// fire and provide interval block
timer.fire(intervalBlock: { interval, intervalIndex in
    print("interval value:", interval, "interval index:", intervalIndex)
})

// Output:
// interval value: 0.2 interval index: 0
// interval value: 1.0 interval index: 1
```

2. A timer that fires at the intervals `[0.0, 0.5, 0.8, 1.0]` over a `6.0` second `fullDuration`. This translates to the timer firing after `0, 3, 4.8` and `6` seconds from firing the timer. We then will try to cancel the timer after `4` seconds.

```swift
// initialize
let timer = MultiIntervalTimer(intervals: [0.0, 0.5, 0.8, 1.0], fullDuration: 6.0)

//fire and provide interval block
timer.fire(intervalBlock: { interval, intervalIndex in
    print("interval value:", interval, "interval index:", intervalIndex)
})

// Cancel after 4 seconds. This should prevent intervals 0.8 and 1.0 from firing
let cancellationTime = DispatchTime.now() + DispatchTimeInterval.seconds(4)
DispatchQueue.main.asyncAfter(deadline: cancellationTime) {
    timer.cancel()
}

// Output:
// interval value: 0.0 interval index: 0
// interval value: 0.5 interval index: 1
```

## TODOs
- Provide default intervals. For example a set of intervals that represent an EaseOut curve.
- Option to fire at the start and end of the fullDuration.
- Maybe find a better name than `MultIntervalTimer`. Is the use of `interval` clear or not? Let me know :)
