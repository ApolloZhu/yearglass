/*
 MIT License

 Copyright (c) 2017 Apollo Zhu (朱智语)
 Copyright © 2015-2017 WWITDC. All rights reserved.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

// Created by Apollo Zhu on 3/4/17.
import Foundation

let info = ProcessInfo.processInfo

struct Option {
    static let prompt = Option(envName: "YEARGLASS_PROMPT", argName: "prompt")
    // TODO: percentage or actual number
    static let style = Option(envName: "YEARGLASS_PROMPT", argName: "style")
    static let fill = Option(envName: "YEARGLASS_FILL", argName: "fill")
    static let empty = Option(envName: "YEARGLASS_EMPTY", argName: "empty")
    static let barLeft = Option(envName: "YEARGLASS_BAR_LEFT", argName: "left")
    static let barRight = Option(envName: "YEARGLASS_BAR_RIGHT", argName: "right")
    static let all = [prompt, fill, empty, barLeft, barRight]

    let envName: String
    let argName: String
}

func env(_ option: Option) -> String? {
    return info.environment[option.envName]
}

var args = info.arguments
func store(_ option: Option?, value: String) {
    if let option = option {
        setenv(option.envName, value, 1)
    }
}

if args.contains("-update") {
    // TODO: Update
    exit(0)
} else if args.contains("-reset") {
    // TODO: Clear ENV
} else {
    var i = 0
    while i < args.count - 1 {
        let cur = args[i], val = args[i+1]
        if cur.hasPrefix("-") && !val.hasPrefix("-") {
            let option = Option.all.first { "-\($0.argName)" == cur }
            store(option, value: val)
            i += 2
        } else {
            i += 1
        }
    }
}

var prompt = env(.prompt) ?? "Year Progress"
var filled = env(.fill) ?? "▓"
var empty  = env(.empty) ?? "░"
var barLeft = env(.barLeft) ?? ""
var barRight = env(.barRight) ?? ""

let calendar = Calendar.current
let today = Date()

var start = Date()
var interval : TimeInterval = 0
_ = calendar.dateInterval(of: .year, start: &start, interval: &interval, for: today)
let daysInYear = calendar.dateComponents([.day], from: start, to: start.addingTimeInterval(interval)).day!
let daysPassed = calendar.ordinality(of: .day, in: .year, for: today)!
let percentage = floor(Double(daysPassed)/Double(daysInYear)*100)/100
// TODO: Option - Show actual numbers of days, \(daysPassed)/\(daysInYear)
let out = NumberFormatter.localizedString(from: percentage as NSNumber, number: .percent)

var width: Int {
    var size = winsize()
    _ = ioctl(STDOUT_FILENO, TIOCGWINSZ, &size)
    return Int(size.ws_col)
}

let widthForBar = width-3 - [prompt,out,barLeft,barRight].reduce(0) { $0+$1.characters.count }
let widthForFilled = Int(percentage*Double(widthForBar))
let countForFilled = widthForFilled/filled.characters.count
let countForEmpty = (widthForBar-widthForFilled)/empty.characters.count

// "a"*3 -> aaa
func *(str: String, count: Int) -> String {
    return count < 0 ? "" : (0..<count).reduce("") { (built,_) in built+str }
}

print("\(prompt): \(out) \(barLeft)\(filled * countForFilled)\(empty * countForEmpty)\(barRight)")
