// Created by Apollo Zhu on 3/4/17.
import Foundation
import yearglass

func parseArguments() {
    let args = ProcessInfo.processInfo.arguments

    for var i in 0..<args.count {
        let cur = args[i]
        if cur.hasPrefix("-") {
            if cur == "-update" {
                fatalError("Not supported yet")
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
let prompt = env(.prompt) ?? defaults(.prompt) ?? val(.prompt)
let filled = env(.fill) ?? defaults(.fill) ?? val(.fill)
let empty  = env(.empty) ?? defaults(.empty) ?? val(.empty)
let barLeft = env(.barLeft) ?? defaults(.barLeft) ?? val(.barLeft)
let barRight = env(.barRight) ?? defaults(.barRight) ?? val(.barRight)

var width: Int {
    var size = winsize()
    _ = ioctl(STDOUT_FILENO, TIOCGWINSZ, &size)
    return Int(size.ws_col)
}

let format: Year.DescriptionFormat = env(.numerical) != nil ? .fraction : .percentage
let out = Year.glass.description(in: format)
let widthForBar = width-3 - [prompt,out,barLeft,barRight].reduce(0) { $0+count($1) }
let bar = Year.glass.barOfWidth(widthForBar)
print("\(prompt): \(out) \(barLeft)\(bar)\(barRight)")
