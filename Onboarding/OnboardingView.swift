import SwiftUI

struct OnboardingView: View {
    let imageName: String
    let title: String
    let description: String
    let progress: Double
    let screenSize: CGSize
    let isPad: Bool
    let isLandscape: Bool
    let onNext: () -> Void

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            let minDimension = min(screenSize.width, screenSize.height)

            VStack {
                ProgressView(value: progress)
                    .tint(Color.darkBlue)
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: minDimension * (isLandscape ? (isPad ? 0.35 : 0.3) : (isPad ? 0.5 : 0.8)))
                    .padding(.vertical, minDimension * (isLandscape ? (isPad ? 0.03 : 0.05) : (isPad ? 0.08 : 0.1)))

                Text(title)
                    .font(.system(size: minDimension * (isLandscape ? (isPad ? 0.04 : 0.03) : (isPad ? 0.05 : 0.06)), weight: .bold))
                    .foregroundColor(Color.darkBlue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, minDimension * 0.02)

                Text(description)
                    .font(.system(size: minDimension * (isLandscape ? (isPad ? 0.03 : 0.03) : (isPad ? 0.04 : 0.05)),weight: .light))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()
            }
            .padding(minDimension * 0.10)
            .padding(.top, 20)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: onNext) {
                        Circle()
                            .fill(Color.darkBlue)
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                            )
                            .shadow(radius: 5)
                            .padding(40)
                    }
                }
            }
        }
    }
}

struct OnboardingFlowView: View {
    @StateObject private var viewModel = OnboardingFlowViewModel()

    var body: some View {
        if viewModel.onboardingCompleted {
            CameraView()
        } else {
            GeometryReader { geometry in
                ZStack {
                    Color.white.ignoresSafeArea()
                    let screenSize = geometry.size
                    let isPad = UIDevice.current.userInterfaceIdiom == .pad
                    let isLandscape = screenSize.width > screenSize.height

                    if !viewModel.isTransitioning || viewModel.fadeOutCurrent {
                        OnboardingView(
                            imageName: viewModel.currentScreen.content.imageName,
                            title: viewModel.currentScreen.content.title,
                            description: viewModel.currentScreen.content.description,
                            progress: viewModel.currentScreen.progress,
                            screenSize: screenSize,
                            isPad: isPad,
                            isLandscape: isLandscape,
                            onNext: viewModel.nextScreen
                        )
                        .opacity(viewModel.fadeOutCurrent ? 0 : 1)
                        .animation(viewModel.fadeOutCurrent ? .easeOut(duration: 0.5) : .none, value: viewModel.fadeOutCurrent)
                    }
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}

class OnboardingFlowViewModel: ObservableObject {
    @Published var currentScreen: OnboardingScreen = .screen1
    @Published var onboardingCompleted = false
    @Published var isTransitioning = false
    @Published var fadeOutCurrent = false

    func nextScreen() {
        guard let next = currentScreen.next else {
            onboardingCompleted = true
            return
        }
        transition(to: next)
    }

    private func transition(to nextScreen: OnboardingScreen) {
        fadeOutCurrent = true
        isTransitioning = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.currentScreen = nextScreen
            self.fadeOutCurrent = false
            withAnimation(.easeIn(duration: 0.5)) {
                self.isTransitioning = false
            }
        }
    }
}

struct OnboardingContent {
    let imageName: String
    let title: String
    let description: String
}

enum OnboardingScreen: Int, CaseIterable {
    case screen1, screen2, screen3, screen4, screen5, screen6

    var content: OnboardingContent {
        switch self {
        case .screen1:
            return OnboardingContent(imageName: "BGPoorPosture", title: "1.7 billion affected \nwith poor posture", description: "Poor posture contributes to musculoskeletal disorders affecting approximately 1.7 billion people globally!")
        case .screen2:
            return OnboardingContent(imageName: "BGTexting", title: "Texting", description: "Bending your head forward to look at a phone can increase the stress on your neck up to 60 pounds!")
        case .screen3:
            return OnboardingContent(imageName: "BGSitting", title: "Sitting", description: "On average, people spend over 8 hours a day sitting!")
        case .screen4:
            return OnboardingContent(imageName: "BGStretching", title: "Stretching", description: "Daily stretching can reduce pain and improve your overall posture!")
        case .screen5:
            return OnboardingContent(imageName: "BGDiagnose", title: "Diagnose and Exercise", description: "We'll diagnose your posture status and provide exercises to improve your posture!")
        case .screen6:
            return OnboardingContent(imageName: "BGAccurate", title: "For Accurate Results", description: """
                Stand naturally.
                Stand with your side.
                Ensure good lighting.
                Place your phone 2 meters away.
                Wear tight clothes.
                Works in portrait orientation.
                """)
        }
    }

    var progress: Double {
        Double(rawValue + 1) / Double(OnboardingScreen.allCases.count)
    }

    var next: OnboardingScreen? {
        OnboardingScreen(rawValue: rawValue + 1)
    }
}

