// Created by Apollo Zhu on 3/4/17.
import yearglass

CLI.parseArguments()
let prompt = val(.prompt)
let barLeft = val(.barLeft)
let barRight = val(.barRight)

let prefersFraction = env(.fraction) ?? defaults(.fraction) != nil
let format: Year.DescriptionFormat = prefersFraction ? .fraction : .percentage
let out = Year.glass.description(in: format)
let widthForBar = CLI.width - 3 - [prompt,out,barLeft,barRight].reduce(0) { $0+$1.yg_count }
let bar = Year.glass.barOfWidth(widthForBar, fillWith: val(.fill), reserveUsing: val(.empty))
print("\(prompt): \(out) \(barLeft)\(bar)\(barRight)")
