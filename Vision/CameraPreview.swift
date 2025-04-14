import SwiftUI

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera: CameraModel

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            if let previewLayer = camera.preview {
                previewLayer.frame = view.bounds
                view.layer.addSublayer(previewLayer)
            }
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            camera.preview?.frame = uiView.bounds
        }
    }
}
