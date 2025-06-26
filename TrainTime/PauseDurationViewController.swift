//
//  PauseDurationViewController.swift
//  TrainTime
//
//  Created by Eldar on 26. 6. 2025..
//

import Foundation
import UIKit

class PauseDurationViewController: UIViewController {
    
    var numberOfSets: Int = 1
    var setDuration: Int = 0 // u sekundama
    
    let minutePicker = UIPickerView()
    let secondPicker = UIPickerView()
    let startButton = UIButton(type: .system)
    
    var selectedMinutes = 0
    var selectedSeconds = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Pause duration"
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

        startButton.setTitle("Start Timer", for: .normal)
        startButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startButton)

        NSLayoutConstraint.activate([
            minutePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            minutePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            minutePicker.widthAnchor.constraint(equalToConstant: 100),
            minutePicker.heightAnchor.constraint(equalToConstant: 150),

            secondPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            secondPicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            secondPicker.widthAnchor.constraint(equalToConstant: 100),
            secondPicker.heightAnchor.constraint(equalToConstant: 150),

            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: secondPicker.bottomAnchor, constant: 40)
        ])
    }

    @objc func startTapped() {
        let timerVC = SimpleSetPauseTimerViewController()
        timerVC.numberOfSets = numberOfSets
        timerVC.setDuration = setDuration
        timerVC.pauseDuration = selectedMinutes * 60 + selectedSeconds
        navigationController?.pushViewController(timerVC, animated: true)
    }
}

extension PauseDurationViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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
