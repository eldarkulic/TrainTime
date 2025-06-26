//
//  SetDurationViewController.swift
//  TrainTime
//
//  Created by Eldar on 26. 6. 2025..
//

import Foundation
import UIKit

class SetDurationViewController: UIViewController {
    
    var numberOfSets: Int = 1
    
    let minutePicker = UIPickerView()
    let secondPicker = UIPickerView()
    let nextButton = UIButton(type: .system)
    
    var selectedMinutes = 0
    var selectedSeconds = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Set duration"
        setupUI()
    }

    func setupUI() {
        minutePicker.delegate = self
        minutePicker.dataSource = self
        minutePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(minutePicker)

        secondPicker.delegate = self
        secondPicker.dataSource = self
        secondPicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(secondPicker)

        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextButton)

        NSLayoutConstraint.activate([
            minutePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            minutePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            minutePicker.widthAnchor.constraint(equalToConstant: 100),
            minutePicker.heightAnchor.constraint(equalToConstant: 150),

            secondPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            secondPicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            secondPicker.widthAnchor.constraint(equalToConstant: 100),
            secondPicker.heightAnchor.constraint(equalToConstant: 150),

            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.topAnchor.constraint(equalTo: secondPicker.bottomAnchor, constant: 40)
        ])
    }

    @objc func nextTapped() {
        let pauseVC = PauseDurationViewController()
        pauseVC.numberOfSets = numberOfSets
        pauseVC.setDuration = selectedMinutes * 60 + selectedSeconds
        navigationController?.pushViewController(pauseVC, animated: true)
    }
}

extension SetDurationViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 60
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(format: "%02d", row)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == minutePicker {
            selectedMinutes = row
        } else {
            selectedSeconds = row
        }
    }
}
