import SwiftUI

struct WelcomeView: View {
    let onDone: (String, String, String) -> Void
    @State private var name = ""
    @State private var focus = "Study & learning"
    @State private var style = "Gentle encouragement"
    @State private var showMatch = false
    private let focuses = ["Study & learning", "Work & career", "Health & wellbeing", "Creative projects"]
    private let styles = ["Gentle encouragement", "Direct check-ins", "Celebrate small wins"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    HStack(spacing: 9) { Image(systemName: "sparkle").foregroundStyle(ABColor.green); Text("AccountaBuddy").font(.system(size: 17, weight: .bold, design: .rounded)).foregroundStyle(ABColor.ink) }
                    VStack(alignment: .leading, spacing: 10) {
                        Text("A little progress,\ntogether.").font(.system(size: 38, weight: .bold, design: .rounded)).foregroundStyle(ABColor.ink).fixedSize(horizontal: false, vertical: true)
                        Text("Tell us how you like to work. We’ll find a buddy who gets it.").font(.system(size: 16)).foregroundStyle(ABColor.muted).lineSpacing(3)
                    }
                    VStack(alignment: .leading, spacing: 17) {
                        fieldLabel("What should we call you?")
                        TextField("Your first name", text: $name).textContentType(.givenName).padding(15).background(.white, in: RoundedRectangle(cornerRadius: 15))
                        fieldLabel("What are you working towards?")
                        VStack(spacing: 8) { ForEach(focuses, id: \.self) { option in choice(option, selected: focus == option) { focus = option } } }
                        fieldLabel("What kind of support feels right?")
                        VStack(spacing: 8) { ForEach(styles, id: \.self) { option in choice(option, selected: style == option) { style = option } } }
                    }
                    Button { showMatch = true } label: { HStack { Text("Find my buddy"); Image(systemName: "arrow.right") }.font(.system(size: 16, weight: .semibold)).foregroundStyle(.white).frame(maxWidth: .infinity).padding(17).background(ABColor.ink, in: Capsule()) }
                    Text("Just you and your buddy. Your goals stay yours to share.").font(.system(size: 12)).foregroundStyle(ABColor.muted).frame(maxWidth: .infinity).multilineTextAlignment(.center)
                }.padding(24)
            }
            .background(ABColor.paper.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $showMatch) { MatchView(onDone: onDone) }
        }
    }

    private func fieldLabel(_ text: String) -> some View { Text(text).font(.system(size: 14, weight: .semibold, design: .rounded)).foregroundStyle(ABColor.ink) }
    private func choice(_ text: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) { HStack { Text(text).font(.system(size: 14, weight: .medium)); Spacer(); Image(systemName: selected ? "checkmark.circle.fill" : "circle").font(.system(size: 18)) }.foregroundStyle(selected ? ABColor.green : ABColor.muted).padding(14).background(selected ? ABColor.mint.opacity(0.5) : .white, in: RoundedRectangle(cornerRadius: 14)).overlay(RoundedRectangle(cornerRadius: 14).stroke(selected ? ABColor.green.opacity(0.35) : .clear, lineWidth: 1)) }
    }
}

struct MatchView: View {
    let onDone: (String, String, String) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var matched = false

    var body: some View {
        VStack(spacing: 22) {
            Spacer()
            ZStack { Circle().fill(ABColor.mint).frame(width: 112, height: 112); Image(systemName: matched ? "person.2.fill" : "sparkles").font(.system(size: 39, weight: .medium)).foregroundStyle(ABColor.green) }
            Text(matched ? "Your buddy is here" : "Finding your kind of person").font(.system(size: 28, weight: .bold, design: .rounded)).foregroundStyle(ABColor.ink)
            Text(matched ? "Meet Jamie — also working on study goals, and likes a kind nudge along the way." : "Matching on your focus and the support style you chose.").font(.system(size: 15)).foregroundStyle(ABColor.muted).multilineTextAlignment(.center).padding(.horizontal, 30)
            if matched {
                HStack(spacing: 12) { Avatar(initial: "J", color: ABColor.peach, size: 52); VStack(alignment: .leading, spacing: 4) { Text("Jamie, 24").font(.system(size: 16, weight: .bold, design: .rounded)).foregroundStyle(ABColor.ink); Text("Study & learning · gentle support").font(.system(size: 12)).foregroundStyle(ABColor.muted) }; Spacer(); Image(systemName: "checkmark.seal.fill").foregroundStyle(ABColor.green) }
                    .padding(16).background(.white, in: RoundedRectangle(cornerRadius: 20)).padding(.horizontal, 24)
                Button { onDone("Alex", "Study & learning", "Gentle encouragement") } label: { Text("Say hello to Jamie").font(.system(size: 16, weight: .semibold)).foregroundStyle(.white).frame(maxWidth: .infinity).padding(17).background(ABColor.ink, in: Capsule()) }.padding(.horizontal, 24)
            } else {
                ProgressView().tint(ABColor.green).padding(.top, 4)
                Button("See my sample match") { withAnimation(.spring(response: 0.45)) { matched = true } }.font(.system(size: 14, weight: .semibold)).foregroundStyle(ABColor.green).padding(.top, 6)
            }
            Spacer()
        }.frame(maxWidth: .infinity).background(ABColor.paper.ignoresSafeArea()).presentationDetents([.large]).presentationDragIndicator(.visible)
    }
}

struct Avatar: View {
    let initial: String
    var color: Color = ABColor.mint
    var size: CGFloat = 42
    var body: some View { Text(initial).font(.system(size: size * 0.38, weight: .bold, design: .rounded)).foregroundStyle(ABColor.ink).frame(width: size, height: size).background(color, in: Circle()) }
}
