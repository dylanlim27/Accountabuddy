# AccountaBuddy iOS MVP

An iOS 17+ SwiftUI starter app for the small, two-person accountability service in the business plan.

## Open the app

Open `AccountaBuddy.xcodeproj` in Xcode on a Mac, select an iPhone simulator, and run the **AccountaBuddy** scheme. The project currently uses local sample data so the main product flows can be explored without a server.

## MVP flows

- Onboarding asks for a first name, focus area, and preferred encouragement style, then shows a sample buddy match.
- Today shows shared progress, upcoming goals, Jamie's sample goal, points, and a quick path to chat.
- Goals supports adding a dated goal, marking goals complete, and collecting points.
- Chat provides a goal-focused conversation view, locally stored messages, and a one-time encouragement action worth 10 points.
- Profile shows a membership tier, points progress, buddy details, and weekly wins.

## Demo limitations

Jamie and the matching result are sample content. Data is stored on the device with `UserDefaults`; there is no account system, live matchmaking, remote messaging, cross-device sync, or push notification service yet. The profile action reopens the sample match flow.
