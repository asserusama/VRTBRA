import SwiftUI

struct ExerciseInstructionView: View {
    @ObservedObject var viewModel: ExerciseViewModel
    @State private var shouldShowExercise = false

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
                        .padding(.horizontal)

                    Image(viewModel.currentExercise.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: minDimension * 0.4, height: minDimension * 0.4)
                        .clipShape(Circle())
                        .padding(.top, 20)

                    Text(viewModel.currentExercise.instructions)
                        .font(.system(size: minDimension * 0.045))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                        .padding(.horizontal, isLandscape ? 150 : 100)

                    Button(action: {
                        viewModel.startExercise()
                        shouldShowExercise = true
                    }) {
                        Text("Start Exercise")
                            .fontWeight(.bold)
                            .font(.system(size: minDimension * 0.05))
                            .padding()
                            .background(Color.darkBlue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 30)
                    }
                }
            }
        }
        .ignoresSafeArea()
        .navigationDestination(isPresented: $shouldShowExercise) {
            CurrentExerciseView(viewModel: viewModel)
        }
    }
}
