//
//  iOSViewController.swift
//  yearglass-iOS
//
//  Created by Apollo Zhu on 12/24/17.
//  Copyright © 2017 yearglass. All rights reserved.
//

import UIKit
import yearglass

class iOSViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate {
    typealias Format = Year.DescriptionFormat
    private var tableView: UITableView? { didSet { tableView?.delegate = self } }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UITableViewController {
            tableView = vc.tableView
        }
    }
    private var data = iOSViewController.preferred { didSet { update() } }
    static let preferred: [Any?] = [
        defaults(.prompt) ?? "Year Progress: ",
        Format(rawValue: defaults(.fraction) ?? "") ?? Format.percentage,
        defaults(.barLeft),
        userDefaults.string(forKey: "WIDTH"),
        defaults(.fill) ?? ">",
        defaults(.empty) ?? "-",
        defaults(.barRight)
    ]
    @IBOutlet weak var text: UILabel?
    @IBOutlet weak var bar: UILabel?
    private func update() {
        let width = Int("\(data[3] ?? 20)") ?? 20
        data[3] = width
        userDefaults.set(width, forKey: "WIDTH")

        for row in 0...6 {
            let cell = tableView?.cellForRow(at: .init(row: row, section: 0))
            cell?.detailTextLabel?.text = "\(data[row] ?? "")"
        }

        let description: String
        if let style = data[1] as? Format {
            description = Year.glass.description(in: style)
            store(.fraction, value: style.rawValue)
        } else if let raw = data[1] as? String,
            let style = Format(rawValue: raw) {
            description = Year.glass.description(in: style) + ""
            store(.fraction, value: raw)
        } else { description = "";store(.fraction, value: nil) }
        var sum = "\(data[0] ?? "")"
        store(.prompt, value: data[0] as? String)
        if !sum.hasSuffix(" ") { sum += " " }
        text?.text = sum + description

        let fill = "\(data[4] ?? "")"
        store(.fill, value: fill)
        let empty = "\(data[5] ?? "")"
        store(.empty, value: empty)
        let progress = Year.glass.barOfWidth(width, fillWith: fill, reserveUsing: empty)
        let barLeft = "\(data[2] ?? "")"
        store(.barLeft, value: barLeft)
        let barRight = "\(data[6] ?? "")"
        store(.barRight, value: barRight)
        bar?.text = barLeft + progress + barRight
    }
    private var indexPath: IndexPath!
    private var alert: UIAlertController!
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexPath = indexPath
        func input(title: String) -> UIAlertController {
            let alert = UIAlertController(title: title, message: nil,
                                          preferredStyle: .alert)
            alert.addTextField {
                $0.delegate = self
                $0.text = "\(self.data[indexPath.row] ?? "")"
            }
            return alert
        }
        switch indexPath.row {
        case 0:
            alert = input(title: "Enter prompt:")
        case 1:
            alert = UIAlertController(title: "Select style", message: nil,
                                      preferredStyle: .actionSheet)
            let all: [Format?] = [.percentage, .fraction, nil]
            let actions = all.map { style in
                UIAlertAction(title: style?.rawValue ?? "none", style: .default) {
                    let format = Format(rawValue: $0.title ?? "")
                    self.data[indexPath.row] = format ?? nil
                }
            }
            actions.forEach { alert.addAction($0) }
        case 2: alert = input(title: "Enter character for bar left:")
        case 3: alert = input(title: "Enter width for bar:")
        case 4: alert = input(title: "Enter character for filled:")
        case 5: alert = input(title: "Enter character for empty:")
        case 6: alert = input(title: "Enter character for bar right:")
        default: fatalError("Index out of bounds: \(indexPath.row)")
        }
        present(alert, animated: true) { }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        tableView?.cellForRow(at: indexPath)?.detailTextLabel?.text = text
        data[indexPath.row] = text
        alert.dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        update()
    }
}
