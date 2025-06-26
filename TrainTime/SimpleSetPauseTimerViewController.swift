//
//  SimpleSetPauseTimerViewController.swift
//  TrainTime
//
//  Created by Eldar on 26. 6. 2025..
//

import UIKit
import AVFoundation

class SimpleSetPauseTimerViewController: UIViewController {

    var numberOfSets: Int = 1
    var setDuration: Int = 0       // u sekundama
    var pauseDuration: Int = 0     // u sekundama

    var currentSet = 1
    var isInSet = true
    var remainingSeconds = 0
    var timer: Timer?
    var isRunning = false
    var isPaused = false

    var audioPlayer: AVAudioPlayer?

    let statusLabel = UILabel()
    let timerLabel = UILabel()
    let pauseResumeButton = UIButton(type: .system)
    let resetButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Workout"
        setupUI()
        startSet()
    }

    func setupUI() {
        statusLabel.font = .systemFont(ofSize: 28, weight: .medium)
        statusLabel.textAlignment = .center
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)

        timerLabel.font = .monospacedDigitSystemFont(ofSize: 48, weight: .semibold)
        timerLabel.textAlignment = .center
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timerLabel)

        pauseResumeButton.setTitle("Pause", for: .normal)
        pauseResumeButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        pauseResumeButton.addTarget(self, action: #selector(pauseResumeTapped), for: .touchUpInside)
        pauseResumeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pauseResumeButton)

        resetButton.setTitle("Reset", for: .normal)
        resetButton.titleLabel?.font = .systemFont(ofSize: 18)
        resetButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resetButton)

        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            timerLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 20),
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            pauseResumeButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 40),
            pauseResumeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            resetButton.topAnchor.constraint(equalTo: pauseResumeButton.bottomAnchor, constant: 20),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    func startSet() {
        isInSet = true
        remainingSeconds = setDuration
        updateUI()
        startTimer()
    }

    func startPause() {
        isInSet = false
        remainingSeconds = pauseDuration
        updateUI()
        startTimer()
    }

    func startTimer() {
        isRunning = true
        isPaused = false
        pauseResumeButton.setTitle("Pause", for: .normal)

        timerLabel.text = timeString(from: remainingSeconds)

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.remainingSeconds -= 1
            self.timerLabel.text = self.timeString(from: self.remainingSeconds)

            if self.remainingSeconds <= 0 {
                self.timer?.invalidate()

                if self.isInSet {
                    // Set finished
                    if self.currentSet < self.numberOfSets {
                        self.startPause()
                    } else {
                        self.finishWorkout()
                    }
                } else {
                    // Pause finished, start next set
                    self.currentSet += 1
                    self.startSet()
                }
            }
        }
    }

    func updateUI() {
        if isInSet {
            statusLabel.text = "Set \(currentSet) of \(numberOfSets)"
        } else {
            statusLabel.text = "Pause before set \(currentSet + 1)"
        }
        timerLabel.text = timeString(from: remainingSeconds)
    }

    @objc func pauseResumeTapped() {
        if isRunning && !isPaused {
            timer?.invalidate()
            isPaused = true
            pauseResumeButton.setTitle("Resume", for: .normal)
        } else {
            startTimer()
        }
    }

    @objc func resetTapped() {
        timer?.invalidate()
        isRunning = false
        isPaused = false
        currentSet = 1
        startSet()
    }

    func finishWorkout() {
        statusLabel.text = "Finished!"
        timerLabel.text = "00:00"
        pauseResumeButton.setTitle("Done", for: .normal)
        pauseResumeButton.isEnabled = false
        playSound()
        showFinishedAlert()
    }

    func timeString(from seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }

    func playSound() {
        if let url = Bundle.main.url(forResource: "beep", withExtension: "wav") {
            audioPlayer = try? AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        }
    }

    func showFinishedAlert() {
        let alert = UIAlertController(title: "Workout complete!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

