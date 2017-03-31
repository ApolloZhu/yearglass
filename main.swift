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

struct YearglassOption {
    static let prompt = YearglassOption(env: "PROMPT", arg: "prompt")
    static let numerical = YearglassOption(env: "STYLE_NUMERICAL", arg: "numerical", hasParam: false)
    static let fill = YearglassOption(env: "FILL", arg: "fill")
    static let empty = YearglassOption(env: "EMPTY", arg: "empty")
    static let barLeft = YearglassOption(env: "BAR_LEFT", arg: "left")
    static let barRight = YearglassOption(env: "BAR_RIGHT", arg: "right")
    static let all = [prompt, numerical, fill, empty, barLeft, barRight]

    let envName: String
    let argName: String
    let requiresParameter: Bool
    private init(env: String, arg: String, hasParam: Bool = true) {
        envName = "YEARGLASS_\(env)"
        argName = "-\(arg)"
        requiresParameter = hasParam
    }
}

func env(_ option: YearglassOption) -> String? {
    return ProcessInfo.processInfo.environment[option.envName]
}

func defaults(_ option: YearglassOption) -> String? {
    return UserDefaults.standard.string(forKey: option.envName)
}

func store(_ option: YearglassOption, value: String?) {
    guard let value = value else { return }
    UserDefaults.standard.set(value, forKey: option.envName)
}

func parseArguments() {
    let args = ProcessInfo.processInfo.arguments

    for var i in 0..<args.count {
        let cur = args[i]
        if cur.hasPrefix("-") {
            if cur == "-update" {
                exit(0) // TODO: Update
            } else if cur == "-reset" {
                YearglassOption.all.forEach {
                    UserDefaults.standard.removeObject(forKey: $0.envName)
                }
                return
            } else if let option = (YearglassOption.all.first { $0.argName == cur }) {
                var val: String? = nil
                if option.requiresParameter && i+1 < args.count {
                    let possible = args[i+1]
                    if !(YearglassOption.all.contains { $0.argName == possible }) {
                        val = possible
                        i += 1
                    }
                }
                store(option, value: option.requiresParameter ? val : "")
            }
        }
    }
}

parseArguments()
let prompt = env(.prompt) ?? defaults(.prompt) ?? "Year Progress"
let filled = env(.fill) ?? defaults(.fill) ?? "▓"
let empty  = env(.empty) ?? defaults(.empty) ?? "░"
let barLeft = env(.barLeft) ?? defaults(.barLeft) ?? ""
let barRight = env(.barRight) ?? defaults(.barRight) ?? ""

let calendar = Calendar.current
let today = Date()

var start = today
var interval: TimeInterval = 0
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
