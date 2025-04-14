import SwiftUI

struct CurrentExerciseView: View {
    @ObservedObject var viewModel: ExerciseViewModel
    @Environment(\.dismiss) var dismiss
    @State private var shouldShowFinishView = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)

                let isLandscape = geometry.size.width > geometry.size.height
                let minDimension = min(geometry.size.width, geometry.size.height)

                VStack {
                    Text(viewModel.currentExercise.name)
                        .font(.system(size: minDimension * 0.07, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.top, isLandscape ? 10 : 20)

                    Image(viewModel.currentExercise.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: minDimension * 0.4, height: minDimension * 0.4)
                        .clipShape(Circle())
                        .padding(.top, 20)

                    Text(formatTime(viewModel.timerValue))
                        .font(.system(size: minDimension * 0.07, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.top, 20)

                    HStack {
                        Button(action: {
                            viewModel.restartExercise()
                        }) {
                            Text("Restart")
                                .fontWeight(.bold)
                                .font(.system(size: minDimension * 0.05))
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(20)

                        Button(action: {
                            if viewModel.isTimerRunning {
                                viewModel.pauseExercise()
                            } else {
                                viewModel.resumeExercise()
                            }
                        }) {
                            Text(viewModel.isTimerRunning ? "Pause" : "Start")
                                .fontWeight(.bold)
                                .font(.system(size: minDimension * 0.05))
                                .padding()
                                .background(Color.darkBlue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(20)
                    }

                    Button(action: {
                        viewModel.skipExercise()

                        if viewModel.isWorkoutComplete {
                            shouldShowFinishView = true
                        } else {
                            dismiss()
                        }
                    }) {
                        Text("Finish")
                            .fontWeight(.bold)
                            .font(.system(size: minDimension * 0.05))
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 20)
                }
                .onAppear {
                    viewModel.pauseExercise()
                }
                .onDisappear {
                    viewModel.stopExerciseSound()
                }
            }
        }
        .navigationDestination(isPresented: $shouldShowFinishView) {
            FinishView()
        }
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
