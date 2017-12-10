//  Created by Apollo Zhu on 12/9/17.
import Foundation

public enum Year {
    /// Shared instance
    case glass
    private var cal: Calendar { return  Calendar.current }
    private var now: Date { return Date() }
    public var daysInYear: Int {
        var start = now
        var interval: TimeInterval = 0
        _ = cal.dateInterval(of: .year, start: &start, interval: &interval, for: now)
        return cal.dateComponents([.day], from: start, to: start.addingTimeInterval(interval)).day!
    }
    public var daysPassed: Int {
        return cal.ordinality(of: .day, in: .year, for: now)!
    }
    public var percentage: Double {
        return floor(Double(daysPassed)/Double(daysInYear)*100)/100
    }
    public func description(in format: DescriptionFormat) -> String {
        switch format {
        case .fraction:
            return "\(daysPassed)/\(daysInYear)"
        case .percentage:
            return NumberFormatter.localizedString(from: percentage as NSNumber, number: .percent)
        }
    }
    public enum DescriptionFormat {
        case fraction, percentage
    }
    public var defaultFilled: String { return "▓" }
    public var defaultEmpty: String { return "░" }
    public func barOfWidth(_ widthForBar: Int,
                           filled: String = Year.glass.defaultFilled,
                           empty: String = Year.glass.defaultEmpty) -> String {
        let widthForFilled = Int(Year.glass.percentage*Double(widthForBar))
        let countForFilled = widthForFilled/count(filled)
        let countForEmpty = (widthForBar-widthForFilled)/count(empty)
        return "\(filled * countForFilled)\(empty * countForEmpty)"
    }
}

/// "a"*3 -> aaa
public func *(str: String, count: Int) -> String {
    return count <= 0 ? "" : (0..<count).reduce("") { (built,_) in built+str }
}

/// For Swift 3 & 4 compatibility.
public func count(_ s: String) -> Int {
    #if swift(>=4.0)
        return s.count
    #else
        return s.characters.count
    #endif
}

