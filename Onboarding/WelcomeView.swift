import SwiftUI

struct WelcomeView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                    .edgesIgnoringSafeArea(.all)

                let isLandscape = geometry.size.width > geometry.size.height
                let minDimension = min(geometry.size.width, geometry.size.height)

                VStack() {
                    Image("BGLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: isLandscape ? minDimension * 0.4 : minDimension * 0.5)
                        .foregroundColor(Color.darkBlue)
                        .padding(.top, 60)
                    Spacer()
                    Image("BGVRTBRA")
                        .resizable()
                        .scaledToFit()
                        .frame(height: isLandscape ? geometry.size.height * 0.25 : geometry.size.height * 0.3)
                        .padding(isLandscape ? 20 : 35)


                    VStack(spacing: isLandscape ? 5 : 8) {
                        Text("DIAGNOSE AND IMPROVE")
                            .font(.system(size: minDimension * 0.05, weight: .regular))
                            .foregroundColor(Color.darkBlue)

                        Text("BAD POSTURE")
                            .font(
                                .system(
                                    size: minDimension * 0.1,
                                    weight: .bold)
                            )
                            .foregroundColor(Color.darkBlue)
                    }
                    .padding(.bottom, isLandscape ? minDimension * 0.05 : minDimension * 0.1)

                    Spacer()

                    NavigationLink(
                        destination: OnboardingFlowView()
                            .edgesIgnoringSafeArea(.all)
                    ) {
                        Text("Get Started")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.darkBlue)
                            .cornerRadius(30)
                            .padding(.horizontal, isLandscape ? minDimension * 0.08 : minDimension * 0.1)
                    }
                    .padding(.bottom, geometry.safeAreaInsets.bottom + 20)
                }
                .padding(.horizontal)
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .navigationBarBackButtonHidden()
    }
}


