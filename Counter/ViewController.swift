//
//  ViewController.swift
//  Counter
//
//  Created by Denis Bokov on 23.07.2025.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var historyChangesTextView: UITextView!
    @IBOutlet private weak var plusButton: UIButton!
    @IBOutlet private weak var minusButton: UIButton!
    @IBOutlet private weak var clearButton: UIButton!
    
    private var counter: Int = 0
    private var history: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyChangesTextView.isEditable = false
        historyChangesTextView.layer.cornerRadius = 10
        historyChangesTextView.text = "История изменений:\n"
        
        changeAppearanceButtons(plusButton, minusButton, clearButton)
        
        counter = UserDefaults.standard.object(forKey: "counter") as? Int ?? 0
        countLabel.text = "\(counter)"
        print("Count: \(counter)")
        
        
        let dateAndText = UserDefaults.standard.object(forKey: "dateAndText") as? String ?? ""
        historyChangesTextView.text = dateAndText
        
        print(historyChangesTextView.text ?? "")
    }
    
    private func changeAppearanceButtons(_ buttons: UIButton...) {
        buttons.forEach { $0.layer.cornerRadius = 10 }
    }
    
    private func updateTextViewAndLabel(for text: String, and labelText: String) {
        historyChangesTextView.text += text
        countLabel.text = labelText
        
        UserDefaults.standard.set(historyChangesTextView.text, forKey: "dateAndText")
    }
    
    @IBAction private func increaseCounter() {
        let date = Date().formatToString(for: .dateFormatter)
        counter += 1
        updateTextViewAndLabel(for: "\(date): значение изменено на +1\n", and: "\(counter)")
        
        UserDefaults.standard.set(counter, forKey: "counter")
    }
    
    @IBAction private func reduceCounter() {
        let date = Date().formatToString(for: .dateFormatter)
        if counter > 0 {
            counter -= 1
            updateTextViewAndLabel(for: "\(date): значение изменено на -1\n", and: "\(counter)")
            
            UserDefaults.standard.set(counter, forKey: "counter")
        } else {
            historyChangesTextView.text += "\(date): попытка уменьшить значение счётчика ниже 0\n"
        }
    }
    
    @IBAction private func clearCounter() {
        let date = Date().formatToString(for: .dateFormatter)
        counter = 0
        updateTextViewAndLabel(for: "\(date): значение сброшено\n", and: "\(counter)")
        
        UserDefaults.standard.set(counter, forKey: "counter")
    }
}

extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy HH:mm:ss"
        return formatter
    }()
}

extension Date {
    func formatToString(for formatter: DateFormatter) -> String {
        return formatter.string(from: self)
    }
}
