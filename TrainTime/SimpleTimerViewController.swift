//
//  SimpleTimerViewController.swift
//  TrainTime
//
//  Created by Eldar on 21. 6. 2025..
//

import UIKit
import AVFoundation

class SimpleTimerViewController: UIViewController {

    let minutePicker = UIPickerView()
    let secondPicker = UIPickerView()
    let timeLabel = UILabel()
    
    let startPauseButton = UIButton(type: .system)
    let resetButton = UIButton(type: .system)
    
    var countdownTimer: Timer?
    var totalSeconds: Int = 0
    var remainingSeconds: Int = 0
    var isRunning = false
    var isPaused = false
    
    var selectedMinutes = 0
    var selectedSeconds = 0
    
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Simple Timer"
        setupUI()
    }

    func setupUI() {
        minutePicker.delegate = self
        minutePicker.dataSource = self
        secondPicker.delegate = self
        secondPicker.dataSource = self
        
        minutePicker.translatesAutoresizingMaskIntoConstraints = false
        secondPicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(minutePicker)
        view.addSubview(secondPicker)

        timeLabel.font = .systemFont(ofSize: 48, weight: .medium)
        timeLabel.textAlignment = .center
        timeLabel.text = "00:00"
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timeLabel)

        startPauseButton.setTitle("Start", for: .normal)
        startPauseButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        startPauseButton.addTarget(self, action: #selector(startPauseTapped), for: .touchUpInside)
        startPauseButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startPauseButton)

        resetButton.setTitle("Reset", for: .normal)
        resetButton.titleLabel?.font = .systemFont(ofSize: 18)
        resetButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resetButton)

        // Layout
        NSLayoutConstraint.activate([
            minutePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            minutePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            minutePicker.widthAnchor.constraint(equalToConstant: 100),
            minutePicker.heightAnchor.constraint(equalToConstant: 150),
            
            secondPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            secondPicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            secondPicker.widthAnchor.constraint(equalToConstant: 100),
            secondPicker.heightAnchor.constraint(equalToConstant: 150),
            
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: minutePicker.bottomAnchor, constant: 30),
            
            startPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startPauseButton.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 40),
            
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.topAnchor.constraint(equalTo: startPauseButton.bottomAnchor, constant: 20)
        ])
    }

    @objc func startPauseTapped() {
        if !isRunning {
            totalSeconds = selectedMinutes * 60 + selectedSeconds
            if totalSeconds == 0 { return } // Ne pokreći ako je nula
            remainingSeconds = totalSeconds
            startTimer()
            isRunning = true
            isPaused = false
            minutePicker.isUserInteractionEnabled = false
            secondPicker.isUserInteractionEnabled = false
            startPauseButton.setTitle("Pause", for: .normal)
        } else if isPaused {
            startTimer()
            isPaused = false
            startPauseButton.setTitle("Pause", for: .normal)
        } else {
            countdownTimer?.invalidate()
            isPaused = true
            startPauseButton.setTitle("Resume", for: .normal)
        }
    }

    @objc func resetTapped() {
        countdownTimer?.invalidate()
        isRunning = false
        isPaused = false
        minutePicker.isUserInteractionEnabled = true
        secondPicker.isUserInteractionEnabled = true
        timeLabel.text = "00:00"
        startPauseButton.setTitle("Start", for: .normal)
    }

    func startTimer() {
        updateLabel()
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.remainingSeconds -= 1
            self.updateLabel()
            if self.remainingSeconds <= 0 {
                self.countdownTimer?.invalidate()
                self.playSound()
                self.showFinishedAlert()
                self.resetTapped()
            }
        }
    }

    func updateLabel() {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
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

extension SimpleTimerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
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

