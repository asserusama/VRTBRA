import AVFoundation
import SwiftUI

@MainActor
class ExerciseViewModel: ObservableObject {
    @Published var currentExerciseIndex: Int = 0
    @Published var isTimerRunning = false
    @Published var isWorkoutComplete = false
    @Published var isReadyForNextExercise = false

    @Published var timerValue: TimeInterval {
        didSet {
            UserDefaults.standard.set(timerValue, forKey: "timerValue")
        }
    }

    private var timer: Timer?
    private var audioPlayer: AVAudioPlayer?

    var currentExercise: Exercise {
        ExerciseList.exercises[currentExerciseIndex]
    }

    init() {
        self.timerValue = UserDefaults.standard.double(forKey: "timerValue")
        if self.timerValue == 0 { 
            self.timerValue = currentExercise.duration
        }
    }

    func loadTimerValue() {
        let savedTime = UserDefaults.standard.double(forKey: "timerValue")
        if savedTime > 0 {
            self.timerValue = savedTime
        }
    }

    func startExercise() {
        if isTimerRunning { return }

        timerValue = currentExercise.duration
        isTimerRunning = true
        isReadyForNextExercise = false
        startTimer()
        playExerciseSound()
    }

    func pauseExercise() {
        timer?.invalidate()
        isTimerRunning = false
        pauseExerciseSound()
    }

    func resumeExercise() {
        if isTimerRunning { return }
        isTimerRunning = true
        startTimer()
        playExerciseSound()
    }

    func restartExercise() {
        timer?.invalidate()
        timerValue = currentExercise.duration
        isReadyForNextExercise = false
        isTimerRunning = true
        startTimer()
        playExerciseSound()
    }

    func skipExercise() {
        if currentExerciseIndex + 1 < ExerciseList.exercises.count {
            currentExerciseIndex += 1
            isReadyForNextExercise = true
            resetTimer()
            resetAudioPlayer()
            playExerciseSound()
        } else {
            isWorkoutComplete = true
            timer?.invalidate()
            isTimerRunning = false
            resetTimer()
            resetAudioPlayer()
        }
    }

    func resetTimer() {
        timer?.invalidate()
        timerValue = currentExercise.duration
        isTimerRunning = false
        isReadyForNextExercise = false
    }

    private func startTimer() {
        timer?.invalidate() 
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self = self else { return }
                if self.timerValue > 0 {
                    self.timerValue -= 1
                } else {
                    self.timer?.invalidate()
                    self.isTimerRunning = false
                    self.isReadyForNextExercise = true
                }
            }
        }
    }

    private func playExerciseSound() {
        if let soundURL = Bundle.main.url(forResource: "exercise_sound", withExtension: "mp3") {
            do {
                if audioPlayer == nil {
                    self.audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                    self.audioPlayer?.prepareToPlay()
                }
                self.audioPlayer?.play()
            } catch {
                print("Error loading sound")
            }
        }
    }

    private func pauseExerciseSound() {
        audioPlayer?.pause()
    }

    private func resetAudioPlayer() {
        audioPlayer?.stop()
        audioPlayer = nil
    }

    func stopExerciseSound() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}
