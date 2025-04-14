import SwiftUI

struct FinishView: View {
    var minDimension: CGFloat {
        min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    }
    
    var body: some View {
        ZStack{
            Color.white
            VStack {
                Image("BGFinish")
                    .resizable()
                    .scaledToFit()
                    .frame(width: minDimension * 1, height: minDimension * 0.7)
                
                Text("Congratulations!\nYou finished your workout")
                    .font(.system(size: minDimension * 0.04))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.darkBlue)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 30)

                NavigationLink(destination: WelcomeView()){
                    Text("Main Menu")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.darkBlue)
                        .cornerRadius(20)
                        .padding(.horizontal, minDimension * 0.2)
                }
                NavigationLink(destination: ExerciseListView(viewModel: ExerciseViewModel())){
                    Text("Workout again")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.indigo)
                        .cornerRadius(20)
                    
                        .padding(.horizontal, minDimension * 0.2) 
                    
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden()
        
    }
}


