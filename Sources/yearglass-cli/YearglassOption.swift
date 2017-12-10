//  Created by Apollo Zhu on 12/9/17.
import Foundation
import yearglass

public struct YearglassOption {
    public static let prompt = YearglassOption(env: "PROMPT", arg: "prompt", val: "Year Progress")
    public static let numerical = YearglassOption(env: "STYLE_NUMERICAL", arg: "numerical", hasParam: false)
    public static let fill = YearglassOption(env: "FILL", arg: "fill", val: Year.glass.defaultFilled)
    public static let empty = YearglassOption(env: "EMPTY", arg: "empty", val: Year.glass.defaultEmpty)
    public static let barLeft = YearglassOption(env: "BAR_LEFT", arg: "left")
    public static let barRight = YearglassOption(env: "BAR_RIGHT", arg: "right")
    public static let all = [prompt, numerical, fill, empty, barLeft, barRight]
    
    public let envName: String
    public let argName: String
    public let `default`: String
    public let requiresParameter: Bool
    private init(env: String, arg: String, val: String = "", hasParam: Bool = true) {
        envName = "YEARGLASS_\(env)"
        argName = "-\(arg)"
        `default` = val
        requiresParameter = hasParam
    }
}

func env(_ option: YearglassOption) -> String? {
    return ProcessInfo.processInfo.environment[option.envName]
}

func defaults(_ option: YearglassOption) -> String? {
    return UserDefaults.standard.string(forKey: option.envName)
}

func val(_ option: YearglassOption) -> String {
    return option.`default`
}

func store(_ option: YearglassOption, value: String?) {
    guard let value = value else { return }
    UserDefaults.standard.set(value, forKey: option.envName)
}
