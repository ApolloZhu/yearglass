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

struct YearglassOption: Equatable {
    static let prompt = YearglassOption(env: "YEARGLASS_PROMPT", arg: "prompt")
    static let numerical = YearglassOption(env: "YEARGLASS_STYLE_NUMERICAL", arg: "numerical", hasParam: false)
    static let fill = YearglassOption(env: "YEARGLASS_FILL", arg: "fill")
    static let empty = YearglassOption(env: "YEARGLASS_EMPTY", arg: "empty")
    static let barLeft = YearglassOption(env: "YEARGLASS_BAR_LEFT", arg: "left")
    static let barRight = YearglassOption(env: "YEARGLASS_BAR_RIGHT", arg: "right")
    static let all = [prompt, numerical, fill, empty, barLeft, barRight]

    let envName: String
    let argName: String
    let requiresParameter: Bool
    private init(env envName: String, arg argName: String, hasParam requiresParameter: Bool = true) {
        self.envName = envName
        self.argName = argName
        self.requiresParameter = requiresParameter
    }
    public static func ==(lhs: YearglassOption, rhs: YearglassOption) -> Bool {
        return lhs.envName == rhs.envName && lhs.argName == rhs.argName
    }
}

func env(_ option: YearglassOption) -> String? {
    return info.environment[option.envName]
}

var args = info.arguments
func store(_ option: YearglassOption?, value: String?) {
    if let option = option, let value = value {
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
    while i < args.count {
        let cur = args[i]
        if cur.hasPrefix("-") {
            if let option = YearglassOption.all.first(where: {"-\($0.argName)" == cur}) {
                var val: String? = nil
                if option.requiresParameter && i+1 < args.count {
                    let possible = args[i+1].trimmingCharacters(in: .whitespacesAndNewlines)
                    if possible.characters.count > 0 && !YearglassOption.all.contains(where: {"-\($0.argName)" == possible}) {
                        val = possible
                        i += 1
                    }
                }
                store(option, value: option.requiresParameter ? val : "")
            }
        }
        i += 1
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
let out = env(.numerical) != nil ? "\(daysPassed)/\(daysInYear)" : NumberFormatter.localizedString(from: percentage as NSNumber, number: .percent)

var width: Int {
    var size = winsize()
    _ = ioctl(STDOUT_FILENO, TIOCGWINSZ, &size)
    return Int(size.ws_col)
}

let widthForBar = width-3 - [prompt,out,barLeft,barRight].reduce(0) { $0+$1.characters.count }
let widthForFilled = Int(percentage*Double(widthForBar))
let countForFilled = widthForFilled/filled.characters.count
let countForEmpty = (widthForBar-widthForFilled)/empty.characters.count

/// "a"*3 -> aaa
func *(str: String, count: Int) -> String {
    return count < 0 ? "" : (0..<count).reduce("") { (built,_) in built+str }
}

print("\(prompt): \(out) \(barLeft)\(filled * countForFilled)\(empty * countForEmpty)\(barRight)")
