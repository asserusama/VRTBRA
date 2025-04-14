import SwiftUI

struct CameraView: View {
    @StateObject private var camera = CameraModel(bodyPoseEstimator: BodyDetection(), postureAnalyzer: PostureAnalyzer())
    @State private var isLandscape = UIDevice.current.orientation.isLandscape  

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let capturedPhoto = camera.capturedPhoto {
                    Image(uiImage: capturedPhoto)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .shadow(radius: 10)
                } else if camera.isPreviewReady {
                    CameraPreview(camera: camera)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .shadow(radius: 10)

                    BodyStickFigureView(bodyPartsEstimates: camera.bodyPoseEstimator, size: geometry.size)
                        .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                } else {
                    Text("Starting Camera..")
                        .foregroundColor(.white)
                }

                VStack {
                    Spacer()

                    if camera.isTaken {
                        VStack {
                            NavigationLink(destination: ExerciseListView(viewModel: ExerciseViewModel())) {
                                Spacer()
                                Text("Exercises")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color.darkBlue)
                                    .cornerRadius(30)
                                    .overlay(Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .padding(.trailing, 20))
                            }
                            Button(action: camera.retakePic) {
                                Text("Retake")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color.red)
                                    .cornerRadius(30)
                            }
                        }
                    } else {
                        VStack {
                            Text(camera.postureStatus)
                                .font(.system(size: 30))
                                .foregroundStyle(camera.postureStatus == "Good Posture" ? .green : .red)
                                .padding(20)
                                .background(Color.black.opacity(0.6))
                                .clipShape(Rectangle())
                                .cornerRadius(20)

                            Spacer()

                            ZStack {
                                Button(action: camera.startCountdown) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 65, height: 65)

                                        Circle()
                                            .stroke(Color.white, lineWidth: 2)
                                            .frame(width: 75, height: 75)
                                    }
                                }

                                HStack {
                                    Spacer()
                                    Button(action: camera.flipCamera) {
                                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                                            .foregroundStyle(.black)
                                            .padding()
                                            .background(Color.white)
                                            .clipShape(Circle())
                                    }
                                    .padding(.trailing, 20)
                                }

                                HStack {
                                    Text("\(camera.timerCount)")
                                        .foregroundStyle(.black)
                                        .padding()
                                        .background(Color.white)
                                        .clipShape(Circle())
                                        .padding(.leading, 20)

                                    Spacer()
                                }
                            }
                        }
                    }
                }
                .padding(50)


                if isLandscape {
                    ZStack {
                        Color.black.opacity(0.9)
                            .edgesIgnoringSafeArea(.all)

                        VStack {
                            Text("Please rotate your phone vertically")
                                .font(.title)
                                .bold()
                                .foregroundColor(.white)
                                .padding()

                            Image(systemName: "iphone")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 100)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .onAppear {
                camera.check()
                updateOrientation()
                NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { _ in
                    updateOrientation()
                }
            }
            .onDisappear {
                camera.stopSession()
                NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
            }
            .alert(isPresented: $camera.alert) {
                Alert(
                    title: Text("Camera Access Denied"),
                    message: Text("Please enable camera access in settings to use this feature."),
                    primaryButton: .default(Text("Settings"), action: {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL)
                        }
                    }),
                    secondaryButton: .cancel()
                )
            }
        }
        .navigationBarBackButtonHidden()
    }

    private func updateOrientation() {
        let orientation = UIDevice.current.orientation
        isLandscape = orientation == .landscapeLeft || orientation == .landscapeRight
    }
}
