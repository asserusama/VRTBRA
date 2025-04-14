import SwiftUI

@main
struct VRTBRA: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WelcomeView()
            }
        }
    }
}


extension Color {
    static let darkBlue = Color( red: 42 / 255, green: 42 / 255, blue: 149 / 255)
}
