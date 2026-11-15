import SwiftUI

enum AppTab: String, CaseIterable {
    case home = "Today", goals = "Goals", chat = "Chat", profile = "Profile"
    var icon: String {
        switch self { case .home: "house.fill"; case .goals: "checklist"; case .chat: "bubble.left.and.bubble.right.fill"; case .profile: "person.crop.circle.fill" }
    }
}

struct RootView: View {
    @EnvironmentObject private var store: BuddyStore
    @State private var selectedTab: AppTab = .home
    @State private var showMatch = false

    var body: some View {
        Group {
            if store.hasOnboarded {
                TabView(selection: $selectedTab) {
                    HomeView(onChat: { selectedTab = .chat }).tag(AppTab.home).tabItem { Label(AppTab.home.rawValue, systemImage: AppTab.home.icon) }
                    GoalsView().tag(AppTab.goals).tabItem { Label(AppTab.goals.rawValue, systemImage: AppTab.goals.icon) }
                    ChatView().tag(AppTab.chat).tabItem { Label(AppTab.chat.rawValue, systemImage: AppTab.chat.icon) }
                    ProfileView(onFindBuddy: { showMatch = true }).tag(AppTab.profile).tabItem { Label(AppTab.profile.rawValue, systemImage: AppTab.profile.icon) }
                }
                .tint(ABColor.ink)
            } else {
                WelcomeView(onDone: store.finishOnboarding)
            }
        }
        .sheet(isPresented: $showMatch) { MatchView(onDone: { name, focus, style in store.finishOnboarding(name: name, focus: focus, style: style); showMatch = false }) }
    }
}

enum ABColor {
    static let ink = Color(red: 0.12, green: 0.18, blue: 0.25)
    static let muted = Color(red: 0.43, green: 0.49, blue: 0.53)
    static let mint = Color(red: 0.75, green: 0.91, blue: 0.82)
    static let green = Color(red: 0.16, green: 0.48, blue: 0.35)
    static let paper = Color(red: 0.97, green: 0.97, blue: 0.94)
    static let peach = Color(red: 1.0, green: 0.87, blue: 0.75)
}

struct Page: ViewModifier {
    func body(content: Content) -> some View {
        content.background(ABColor.paper.ignoresSafeArea()).toolbarBackground(ABColor.paper, for: .tabBar)
    }
}
extension View { func abPage() -> some View { modifier(Page()) } }

struct Eyebrow: View {
    let text: String
    var body: some View { Text(text.uppercased()).font(.system(size: 11, weight: .bold, design: .rounded)).tracking(1.1).foregroundStyle(ABColor.muted) }
}

struct SectionTitle: View {
    let title: String
    var action: (() -> Void)? = nil
    var actionTitle: String = "See all"
    var body: some View {
        HStack {
            Text(title).font(.system(size: 20, weight: .bold, design: .rounded)).foregroundStyle(ABColor.ink)
            Spacer()
            if let action { Button(actionTitle, action: action).font(.system(size: 13, weight: .semibold)).foregroundStyle(ABColor.green) }
        }
    }
}
