//
//  ViewController.swift
//  TrainTime
//
//  Created by Eldar on 21. 6. 2025..
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Train Time"

        setupUI()
    }

    func setupUI() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])

        // Option 1: Simple Timer
        let simpleButton = createButton(title: "Start Simple Timer", action: #selector(startSimpleTimer))
        let simpleLabel = createDescription("This is a basic timer that runs for a set duration.")
        stackView.addArrangedSubview(simpleButton)
        stackView.addArrangedSubview(simpleLabel)

        // Option 2: Simple Set-Pause Timer
        let setPauseButton = createButton(title: "Start Set-Pause Timer", action: #selector(startSetPauseTimer))
        let setPauseLabel = createDescription("Repeats a set-pause pattern for a fixed number of rounds.")
        stackView.addArrangedSubview(setPauseButton)
        stackView.addArrangedSubview(setPauseLabel)

        // Option 3: Custom Timer
        let customButton = createButton(title: "Start Custom Timer", action: #selector(startCustomTimer))
        let customLabel = createDescription("Customize durations for each set and pause individually.")
        stackView.addArrangedSubview(customButton)
        stackView.addArrangedSubview(customLabel)
    }

    func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    func createDescription(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }

    // Placeholder actions
    @objc func startSimpleTimer() {
        print("Navigate to Simple Timer")
        let vc = SimpleTimerViewController()
            navigationController?.pushViewController(vc, animated: true)
    }

    @objc func startSetPauseTimer() {
        print("Navigate to Set-Pause Timer")
    }

    @objc func startCustomTimer() {
        print("Navigate to Custom Timer")
    }
}


