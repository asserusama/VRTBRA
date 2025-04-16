**VRTBRA** is an iOS application focused on diagnosing poor posture and helping users improve it through guided exercises. The logo represents a “V” made of two bones, symbolizing spinal health and balance.

![IMG_2470-3](https://github.com/user-attachments/assets/6f60b1a0-cd08-4f2d-a451-677b6a903cf5)


### Features

- **Welcome & Onboarding:** Smooth SwiftUI-based screens with animations and educational posture facts to introduce the problem and purpose of the app.  
- **Posture Analysis:** Utilizes Vision and AVFoundation to detect 5 key body joints (head to ankle) in real-time through the camera. Users are guided to position themselves correctly before detection.  
- **Posture Detection Logic:** Calculates the angle between the head (ear) and shoulder using Euclidean distance and trigonometric functions to determine posture accuracy.  
- **Audio Feedback:** Voice prompts inform users if posture is good or bad based on the calculated angle, at the end of a countdown timer.  
- **Result & Feedback:** After analysis, a snapshot preview is shown with feedback and options to retake or proceed.  
- **Exercise Module:** Includes 10 posture-improving exercises with instructions, a one-minute timer, and relaxing background music. Users can skip, restart, or finish anytime.  
- **Session Completion:** Ends with a congratulatory screen and options to redo exercises or return to the main menu.

### Future Improvements

- Integrate posture tracking history and performance analytics.  
- Add personalized exercise plans based on user posture trends.  
- Implement daily reminders and notifications to maintain good posture habits.
