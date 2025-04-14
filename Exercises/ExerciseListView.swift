import SwiftUI

struct ExerciseListView: View {
    @ObservedObject var viewModel: ExerciseViewModel
    @State private var shouldShowInstructions = false

    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            let minDimension = min(geometry.size.width, geometry.size.height)

            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                VStack {
                    headerView(minDimension: minDimension, isLandscape: isLandscape)
                    durationView(minDimension: minDimension)
                    exerciseListView(minDimension: minDimension)
                }
            }
        }
        .navigationDestination(isPresented: $shouldShowInstructions) {
            ExerciseInstructionView(viewModel: viewModel)
        }
    }

    private func headerView(minDimension: CGFloat, isLandscape: Bool) -> some View {
        VStack {
            Text("Better Posture Workout")
                .font(.system(size: minDimension * 0.07, weight: .bold))
                .foregroundColor(.black)
                .padding(.top, isLandscape ? 10 : 20)
                .padding(.horizontal)

            Text("Warm up properly before exercise!")
                .font(.system(size: minDimension * 0.04))
                .foregroundColor(.gray)
        }
    }

    private func durationView(minDimension: CGFloat) -> some View {
        HStack {
            durationInfoView(minDimension: minDimension)
            NavigationLink(destination: FinishView()) {
                completionButton(minDimension: minDimension)
            }
        }
        .padding()
    }

    private func durationInfoView(minDimension: CGFloat) -> some View {
        HStack {
            Image(systemName: "clock.fill")
                .foregroundColor(.blue)
                .padding(5)
            Text("10 mins")
                .font(.system(size: minDimension * 0.05))
                .foregroundColor(.blue)
                .padding(.trailing)
        }
        .padding(.leading)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }

    private func completionButton(minDimension: CGFloat) -> some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .padding(5)
            Text("Finish")
                .font(.system(size: minDimension * 0.05))
                .foregroundColor(.green)
                .padding(.trailing)
        }
        .padding(.leading)
        .background(Color.green.opacity(0.1))
        .cornerRadius(12)
    }

    private func exerciseListView(minDimension: CGFloat) -> some View {
        List(ExerciseList.exercises, id: \ .name) { exercise in
            exerciseRow(minDimension: minDimension, exercise: exercise)
        }
        .listStyle(PlainListStyle())
    }

    private func exerciseRow(minDimension: CGFloat, exercise: Exercise) -> some View {
        HStack {
            exerciseThumbnail(minDimension: minDimension, exercise: exercise)
            exerciseDetails(minDimension: minDimension, exercise: exercise)
            Spacer()
            startExerciseButton(minDimension: minDimension, exercise: exercise)
        }
        .padding(.vertical, 12)
        .cornerRadius(10)
        .onTapGesture {
            selectExercise(exercise: exercise)
        }
        .background(Color.white)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.white)
    }

    private func exerciseThumbnail(minDimension: CGFloat, exercise: Exercise) -> some View {
        Image(exercise.imageName)
            .resizable()
            .scaledToFill()
            .frame(width: minDimension * 0.12, height: minDimension * 0.12)
            .clipShape(Circle())
            .padding(.horizontal)
    }

    private func exerciseDetails(minDimension: CGFloat, exercise: Exercise) -> some View {
        VStack(alignment: .leading) {
            Text(exercise.name)
                .font(.system(size: minDimension * 0.04))
                .fontWeight(.medium)
                .foregroundColor(.black)

            Text("\(String(format: "%.0f", exercise.duration / 60)) min")
                .font(.system(size: minDimension * 0.035))
                .foregroundColor(.gray)        }
    }

    private func startExerciseButton(minDimension: CGFloat, exercise: Exercise) -> some View {
        Button(action: { selectExercise(exercise: exercise) }) {
            Image(systemName: "play.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: minDimension * 0.1, height: minDimension * 0.1)
                .foregroundColor(Color.darkBlue)
                .padding(.horizontal)
        }
    }

    private func selectExercise(exercise: Exercise) {
        viewModel.currentExerciseIndex = ExerciseList.exercises.firstIndex(where: { $0.name == exercise.name }) ?? 0
        shouldShowInstructions = true
    }
}
