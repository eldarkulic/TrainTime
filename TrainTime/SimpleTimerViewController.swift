//
//  SimpleTimerViewController.swift
//  TrainTime
//
//  Created by Eldar on 21. 6. 2025..
//

import UIKit
import AVFoundation

class SimpleTimerViewController: UIViewController {
    
    let timePicker = UIDatePicker()
    let timeLabel = UILabel()
    let startButton = UIButton(type: .system)

    var countdownTimer: Timer?
    var totalSeconds: Int = 0
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Simple Timer"
        setupUI()
    }

    func setupUI() {
        // Time picker
        timePicker.datePickerMode = .countDownTimer
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timePicker)

        // Time label
        timeLabel.font = .systemFont(ofSize: 48, weight: .medium)
        timeLabel.textAlignment = .center
        timeLabel.text = "00:00"
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timeLabel)

        // Start button
        startButton.setTitle("Start", for: .normal)
        startButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        startButton.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startButton)

        // Layout
        NSLayoutConstraint.activate([
            timePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),

            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 40),

            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 40)
        ])
    }

    @objc func startTimer() {
        totalSeconds = Int(timePicker.countDownDuration)
        updateLabel()
        startButton.isEnabled = false
        timePicker.isEnabled = false

        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.totalSeconds -= 1
            self.updateLabel()
            if self.totalSeconds <= 0 {
                self.countdownTimer?.invalidate()
                self.playSound()
                self.showFinishedAlert()
                self.startButton.isEnabled = true
                self.timePicker.isEnabled = true
            }
        }
    }

    func updateLabel() {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }

    func playSound() {
        if let url = Bundle.main.url(forResource: "beep", withExtension: "wav") {
            audioPlayer = try? AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        }
    }

    func showFinishedAlert() {
        let alert = UIAlertController(title: "Time's up!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

