//
//  NumberOfSetsViewController.swift
//  TrainTime
//
//  Created by Eldar on 26. 6. 2025..
//

import UIKit

class NumberOfSetsViewController: UIViewController {

    let picker = UIPickerView()
    let nextButton = UIButton(type: .system)
    var selectedSets = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "How many sets?"

        picker.delegate = self
        picker.dataSource = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(picker)

        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextButton)

        NSLayoutConstraint.activate([
            picker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            picker.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.topAnchor.constraint(equalTo: picker.bottomAnchor, constant: 40)
        ])
    }

    @objc func nextTapped() {
        let setDurationVC = SetDurationViewController()
        setDurationVC.numberOfSets = selectedSets
        navigationController?.pushViewController(setDurationVC, animated: true)
    }
}

extension NumberOfSetsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 50 // max 50 setova
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSets = row + 1
    }
}

