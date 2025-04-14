import SwiftUI
import Vision

enum BodyPartType: CaseIterable, Hashable, Identifiable {
    case rightEar, rightShoulder, rightHip, rightKnee, rightAnkle

    var id: Self { self }

    var jointName: VNHumanBodyPoseObservation.JointName {
        return [
            .rightEar: .rightEar,
            .rightShoulder: .rightShoulder,
            .rightHip: .rightHip,
            .rightKnee: .rightKnee,
            .rightAnkle: .rightAnkle
        ][self] ?? .nose 
    }

    static let rightBodyLine: [BodyPartType] = [.rightEar, .rightShoulder, .rightHip, .rightKnee, .rightAnkle]
}

struct Shapes: Shape {
    var bodyPoints: [CGPoint]
    var size: CGSize

    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard let firstPoint = bodyPoints.first else { return path }
        path.move(to: firstPoint)

        for point in bodyPoints.dropFirst() {
            path.addLine(to: point)
        }

        return path.applying(CGAffineTransform(scaleX: size.width, y: size.height))
    }
}

func calculateDistance(point1: CGPoint?, point2: CGPoint?) -> CGFloat? {
    guard let p1 = point1, let p2 = point2 else { return nil }
    return p1.distance(to: p2)
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return hypot(point.x - x, point.y - y)
    }
}

extension Shape {
    func flipped() -> ScaledShape<Self> {
        scale(x: -1, y: 1, anchor: .center)
    }
}
