import AVFoundation
import Vision

class BodyDetection: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, ObservableObject {
    let sequenceHandler = VNSequenceRequestHandler()

    @Published var bodyParts = [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]()
    @Published var bodyPartsGroup = [VNHumanBodyPoseObservation.JointsGroupName : VNRecognizedPoint]()

    private var currentOrientation: CGImagePropertyOrientation = .right

    var onPoseDetected: (() -> Void)?

    func updateOrientation(isFrontCamera: Bool) {
        currentOrientation = isFrontCamera ? .leftMirrored : .right
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let humanBodyRequest = VNDetectHumanBodyPoseRequest(completionHandler: detectedBodyPose)
        do {
            try sequenceHandler.perform(
                [humanBodyRequest],
                on: sampleBuffer,
                orientation: currentOrientation
            )
        } catch {
        }
    }

    func detectedBodyPose(request: VNRequest, error: Error?) {
        guard let bodyPoseResults = request.results as? [VNHumanBodyPoseObservation],
              let bodyParts = try? bodyPoseResults.first?.recognizedPoints(.all) else {
            return self.removeBodyPartsFromArray()
        }
        DispatchQueue.main.async {
            self.bodyParts = bodyParts
            self.onPoseDetected?()
        }
    }

    func removeBodyPartsFromArray() {
        DispatchQueue.main.async {
            self.bodyParts.removeAll()
        }
    }
}
