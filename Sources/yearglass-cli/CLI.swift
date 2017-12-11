import Foundation
enum CLI {
    static var width: Int {
        var size = winsize()
        _ = ioctl(STDOUT_FILENO, TIOCGWINSZ, &size)
        return Int(size.ws_col)
    }

    static func parseArguments() {
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
}
