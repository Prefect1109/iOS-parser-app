//
//  DateTextFieldView.swift
//  iOS Parser
//
//  Created by Prefect on 01.04.2022.
//

import UIKit

class DateTextFieldView: UIView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    private var datePicker: UIDatePicker?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("DateTextFieldView", owner: self, options: nil)
        
        addSubview(containerView)
        containerView.frame = self.bounds
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.preferredDatePickerStyle = .wheels
        datePicker?.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        textField.inputView = datePicker
    }

    @objc func dateChanged() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        textField.text = formatter.string(from: datePicker!.date)
    }
}
