import SwiftUI

struct BodyStickFigureView: View {
    @ObservedObject var bodyPartsEstimates: BodyDetection
    var size: CGSize

    var body: some View {
        Group {
            if !bodyPartsEstimates.bodyParts.isEmpty {
                ZStack {
                    drawBodyLine(for: BodyPartType.rightBodyLine)
                    drawJoints(for: BodyPartType.rightBodyLine)
                }
            }
        }
    }

    private func drawBodyLine(for bodyLine: [BodyPartType]) -> some View {
        let points = bodyLine.compactMap { bodyPartsEstimates.bodyParts[$0.jointName]?.location }

        if points.count != bodyLine.count {
            return AnyView(EmptyView())
        }

        return AnyView(
            Path { path in
                guard let firstPoint = points.first else { return }
                path.move(to: CGPoint(x: firstPoint.x * size.width, y: firstPoint.y * size.height))
                for point in points.dropFirst() {
                    path.addLine(to: CGPoint(x: point.x * size.width, y: point.y * size.height))
                }
            }
            .stroke(Color.darkBlue, lineWidth: 2.0)
        )
    }

    private func drawJoints(for joints: [BodyPartType]) -> some View {
        ForEach(joints, id: \ .self) { joint in
            if let bodyPart = bodyPartsEstimates.bodyParts[joint.jointName] {
                Circle()
                    .frame(width: 10, height: 10)
                    .position(x: bodyPart.location.x * size.width, y: bodyPart.location.y * size.height)
                    .foregroundColor(Color.darkBlue)
            }
        }
    }
}

