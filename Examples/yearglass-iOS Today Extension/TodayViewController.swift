//
//  TodayViewController.swift
//  yearglass-iOS Today Extension
//
//  Created by Apollo Zhu on 12/24/17.
//  Copyright © 2017 yearglass. All rights reserved.
//

import UIKit
import NotificationCenter
import yearglass

class TodayViewController: UIViewController, NCWidgetProviding {
    typealias Format = Year.DescriptionFormat
    var style: Format {
        get { return Format(rawValue: val(.fraction)) ?? .percentage }
        set { store(.fraction, value: newValue.rawValue);updateLabel() }
    }

    @IBOutlet weak var label: UILabel? { didSet { updateLabel() } }

    @discardableResult
    private func updateLabel() -> Bool? {
        guard let label = label else { return nil }
        let description = Year.glass.description(in: style)
        let bar = Year.glass.barOfWidth(20, fillWith: val(.fill), reserveUsing: val(.empty))
        let newText = "\(description) \(bar)"
        let oldText = label.text
        label.text = newText
        return oldText == newText
    }

    @IBOutlet weak var switchButton: UIButton!

    @IBAction func `switch`() {
        let identity = style == .percentage
        style = identity ? .fraction :.percentage
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let btn = self?.switchButton else { return }
            btn.transform = CGAffineTransform(scaleX: identity ? -1 : 1, y: 1)
        }
    }

    /// Perform any setup necessary in order to update the view.
    func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        if let updated = updateLabel() {
            completionHandler(updated ? .newData : .noData)
        } else {
            completionHandler(.failed)
        }
    }
}
