import Vision

class PostureAnalyzer: ObservableObject {
    @Published var postureStatus: String = "No Body Detected"

    func analyzePosture(bodyParts: [VNHumanBodyPoseObservation.JointName: VNRecognizedPoint]) {
        guard let rightEar = bodyParts[.rightEar],
              let rightShoulder = bodyParts[.rightShoulder] else {
            DispatchQueue.main.async {
                self.postureStatus = "Cannot detect right ear or right shoulder"
            }
            return
        }

        let dx = rightEar.location.x - rightShoulder.location.x
        let dy = rightEar.location.y - rightShoulder.location.y
        let angleRadians = atan2(dy, dx)
        let angleDegrees = angleRadians * 180 / .pi

        DispatchQueue.main.async {
            if angleDegrees > 75 && angleDegrees < 105 {
                self.postureStatus = "Good Posture"
            } else {
                self.postureStatus = "Bad Posture"
            }
        }
    }
}
