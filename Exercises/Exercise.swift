import Foundation

struct Exercise: Equatable {
    let name: String
    let duration: TimeInterval
    let imageName: String
    let instructions: String 
}

enum ExerciseList {
    static let exercises: [Exercise] = [
        Exercise(
            name: "Neck Rotation",
            duration: 60,
            imageName: "BGNeckRotation",
            instructions: "Rotate your neck gently in a circular motion, first in one direction and then the other. Ensure your movements are smooth and controlled."
        ),
        Exercise(
            name: "Neck Extension",
            duration: 60,
            imageName: "BGNeckExtension",
            instructions: "Sit upright, gently tilt your head backward, and hold the position for a few seconds."
        ),
        Exercise(
            name: "Bridge",
            duration: 60,
            imageName: "BGBridge",
            instructions: "Lie on your back with your knees bent. Lift your hips towards the ceiling, keeping your shoulders on the ground."
        ),
        Exercise(
            name: "Pigeon",
            duration: 60,
            imageName: "BGPigeon",
            instructions: "Sit with one leg bent in front and the other extended behind you. Lower your body to the floor as you stretch the hip of the extended leg."
        ),
        Exercise(
            name: "Side Plank",
            duration: 60,
            imageName: "BGSidePlank",
            instructions: "Lie on your side and lift your hips, supporting your weight on one arm. Hold this position while keeping your body straight."
        ),
        Exercise(
            name: "Plank",
            duration: 60,
            imageName: "BGPlank",
            instructions: "Start in a push-up position and hold your body straight from head to heels, engaging your core and keeping your back flat."
        ),
        Exercise(
            name: "Cow-Cat",
            duration: 60,
            imageName: "BGCowCat",
            instructions: "Start on your hands and knees. Alternate between arching your back (cow pose) and rounding it (cat pose) while breathing deeply."
        ),
        Exercise(
            name: "Fold",
            duration: 60,
            imageName: "BGFold",
            instructions: "Sit on the ground and fold forward from your hips, reach for your toes."
        ),
        Exercise(
            name: "Child",
            duration: 60,
            imageName: "BGChild",
            instructions: "Kneel and sit on your heels. Fold forward with your arms extended out in front of you and rest your forehead on the floor."
        ),
        Exercise(
            name: "Cobra",
            duration: 60,
            imageName: "BGCobra",
            instructions: "Lie on your stomach with your hands under your shoulders. Push your chest upward."
        )
    ]
}
