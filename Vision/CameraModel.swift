import SwiftUI
import AVFoundation
import Photos

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var isTaken: Bool = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCapturePhotoOutput()
    @Published var preview: AVCaptureVideoPreviewLayer?
    @Published var isPreviewReady: Bool = false
    @Published var capturedPhoto: UIImage? = nil
    @Published var currentPosition: AVCaptureDevice.Position = .back
    @Published var timerCount = 5
    @Published var isShowingExerciseListView = false
    @Published var postureStatus: String = "No Body Detected"

    private var timer: Timer?
    private var audioPlayer: AVAudioPlayer?
    var bodyPoseEstimator: BodyDetection
    var postureAnalyzer: PostureAnalyzer

    init(bodyPoseEstimator: BodyDetection, postureAnalyzer: PostureAnalyzer) {
        self.bodyPoseEstimator = bodyPoseEstimator
        self.postureAnalyzer = postureAnalyzer
        super.init()

        bodyPoseEstimator.onPoseDetected = { [weak self] in
            self?.analyzePosture()
        }
    }

    func analyzePosture() {
        postureAnalyzer.analyzePosture(bodyParts: bodyPoseEstimator.bodyParts)
        postureStatus = postureAnalyzer.postureStatus
    }

    func playSound(for posture: String) {
        let soundNames: [String: String] = [
            "Good Posture": "good_posture_sound",
            "Bad Posture": "bad_posture_sound",
            "No Body Detected": "no_body_detected_sound"
        ]

        guard let soundName = soundNames[posture],
              let soundURL = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
        }
    }

    func check() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] success in
                DispatchQueue.main.async {
                    success ? self?.setupSession() : self?.alert.toggle()
                }
            }
        default:
            DispatchQueue.main.async { self.alert.toggle() }
        }
    }

    private func setupSession() {
        session.beginConfiguration()
        defer { session.commitConfiguration() }

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input),
              session.canAddOutput(output) else {
            return
        }

        session.addInput(input)
        session.addOutput(output)

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(bodyPoseEstimator, queue: DispatchQueue(label: "videoQueue"))
        if session.canAddOutput(videoOutput) { session.addOutput(videoOutput) }

        DispatchQueue.main.async {
            self.preview = AVCaptureVideoPreviewLayer(session: self.session)
            self.preview?.videoGravity = .resizeAspectFill
            self.isPreviewReady = true
        }

        startSession()
    }

    func flipCamera() {
        session.beginConfiguration()
        defer { session.commitConfiguration() }

        if let currentInput = session.inputs.first {
            session.removeInput(currentInput)
        }

        currentPosition = (currentPosition == .back) ? .front : .back
        guard let newDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: currentPosition),
              let newInput = try? AVCaptureDeviceInput(device: newDevice),
              session.canAddInput(newInput) else {
            return
        }

        session.addInput(newInput)
        bodyPoseEstimator.updateOrientation(isFrontCamera: currentPosition == .front)
    }

    func startSession() {
        DispatchQueue.global(qos: .userInitiated).async { self.session.startRunning() }
    }

    func stopSession() {
        DispatchQueue.global(qos: .background).async {
            self.session.stopRunning()
            self.session.inputs.forEach { self.session.removeInput($0) }
            self.session.outputs.forEach { self.session.removeOutput($0) }

            DispatchQueue.main.async {
                self.preview = nil
                self.audioPlayer?.stop()
                self.audioPlayer = nil
            }
        }
        timer?.invalidate()
        timer = nil
    }

    func startCountdown() {
        timer?.invalidate()
        timerCount = 5
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.timerCount > 1 {
                self.timerCount -= 1
            } else {
                timer.invalidate()
                self.takePic()
            }
        }
    }

    private func takePic() {
        let settings = AVCapturePhotoSettings()
        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: settings, delegate: self)
        }
    }

    func retakePic() {
        capturedPhoto = nil
        isTaken = false
        timer?.invalidate()
        timerCount = 5
        startSession()
        postureStatus = "No Body Detected"
    }

    private func overlayPostureStatus(on image: UIImage) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: image.size)
        return renderer.image { context in
            image.draw(at: .zero)

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 80),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]

            let text = postureStatus
            let textSize = text.size(withAttributes: attrs)
            let padding: CGFloat = 20
            let backgroundRect = CGRect(
                x: (image.size.width - textSize.width - 2 * padding) / 2,
                y: image.size.height * 0.15,  
                width: textSize.width + 2 * padding,
                height: textSize.height + 2 * padding
            )

            context.cgContext.setFillColor(UIColor.black.withAlphaComponent(0.6).cgColor)
            context.cgContext.fill(backgroundRect)

            text.draw(in: backgroundRect.insetBy(dx: padding, dy: padding), withAttributes: attrs)
        }
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let photoData = photo.fileDataRepresentation(), let image = UIImage(data: photoData) else { return }

        DispatchQueue.main.async {
            self.capturedPhoto = image
            withAnimation { self.isTaken = true }
        }

        DispatchQueue.global(qos: .userInitiated).async {
            let processedImage = self.overlayPostureStatus(on: image)

            DispatchQueue.main.async { self.capturedPhoto = processedImage }
            self.savePhotoToLibrary(image: processedImage)
        }

        playSound(for: postureStatus)
    }

    private func savePhotoToLibrary(image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized || status == .limited else {
                DispatchQueue.main.async { self.alert.toggle() }
                return
            }

            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { success, error in
                if success {
                } else {
                }
            }
        }
    }
}
