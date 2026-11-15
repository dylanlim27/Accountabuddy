import SwiftUI

struct ChatView: View {
    @EnvironmentObject private var store: BuddyStore
    @State private var draft = ""
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack(spacing: 11) { Avatar(initial: "J", color: ABColor.peach, size: 42); VStack(alignment: .leading, spacing: 3) { Text("Jamie").font(.system(size: 16, weight: .bold, design: .rounded)).foregroundStyle(ABColor.ink); Text("Your accountability buddy").font(.system(size: 11)).foregroundStyle(ABColor.muted) }; Spacer(); Image(systemName: "ellipsis").foregroundStyle(ABColor.muted).padding(10) }.padding(.horizontal, 20).padding(.vertical, 12)
                Rectangle().fill(ABColor.ink.opacity(0.06)).frame(height: 1)
                if !store.data.encouragedBuddy {
                    Button { store.encourageBuddy() } label: { Label("Send Jamie encouragement · +10 points", systemImage: "sparkles").font(.system(size: 12, weight: .semibold)).foregroundStyle(ABColor.green).frame(maxWidth: .infinity).padding(11).background(ABColor.mint.opacity(0.4), in: Capsule()) }.padding(.horizontal, 20).padding(.top, 12)
                }
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 15) {
                            Text("A little space just for your goals.").font(.system(size: 11, weight: .medium)).foregroundStyle(ABColor.muted).padding(.top, 18)
                            HStack(spacing: 8) { Image(systemName: "target"); Text("TODAY’S FOCUS").tracking(0.8) }.font(.system(size: 10, weight: .bold)).foregroundStyle(ABColor.green)
                            Text("Finish my project outline").font(.system(size: 13, weight: .semibold, design: .rounded)).foregroundStyle(ABColor.ink).padding(.horizontal, 16).padding(.vertical, 11).background(ABColor.mint.opacity(0.55), in: Capsule())
                            ForEach(store.data.messages) { message in
                                HStack { if !message.fromBuddy { Spacer(minLength: 45) }; VStack(alignment: message.fromBuddy ? .leading : .trailing, spacing: 5) { Text(message.text).font(.system(size: 14)).foregroundStyle(message.fromBuddy ? ABColor.ink : .white).padding(.horizontal, 15).padding(.vertical, 11).background(message.fromBuddy ? Color.white : ABColor.ink, in: RoundedRectangle(cornerRadius: 18)); Text(message.sentAt.formatted(.dateTime.hour().minute())).font(.system(size: 10)).foregroundStyle(ABColor.muted).padding(.horizontal, 5) }; if message.fromBuddy { Spacer(minLength: 45) } }.id(message.id)
                            }
                        }.padding(.horizontal, 18).padding(.bottom, 14)
                    }.onChange(of: store.data.messages.count) { _, _ in if let last = store.data.messages.last { withAnimation { proxy.scrollTo(last.id, anchor: .bottom) } } }
                }
                HStack(spacing: 10) { TextField("Send Jamie a note…", text: $draft, axis: .vertical).lineLimit(1...4).font(.system(size: 14)).padding(.horizontal, 15).padding(.vertical, 11).background(ABColor.paper, in: Capsule()); Button(action: send) { Image(systemName: "arrow.up").font(.system(size: 15, weight: .bold)).foregroundStyle(.white).frame(width: 42, height: 42).background(ABColor.green, in: Circle()) }.disabled(draft.trimmingCharacters(in: .whitespaces).isEmpty) }.padding(.horizontal, 16).padding(.vertical, 11).background(.white)
            }.background(ABColor.paper.ignoresSafeArea()).toolbar(.hidden, for: .navigationBar)
        }
    }
    private func send() { store.send(draft); draft = "" }
}

struct ProfileView: View {
    @EnvironmentObject private var store: BuddyStore
    let onFindBuddy: () -> Void
    private var progress: Double { min(1, Double(store.data.points) / Double(store.nextTierPoints)) }
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 12) { Avatar(initial: String(store.data.name.prefix(1)), size: 76); Text(store.data.name).font(.system(size: 25, weight: .bold, design: .rounded)).foregroundStyle(ABColor.ink); Text("Working on \(store.data.focus.lowercased())").font(.system(size: 13)).foregroundStyle(ABColor.muted) }.frame(maxWidth: .infinity).padding(.vertical, 10)
                    VStack(alignment: .leading, spacing: 13) {
                        HStack { VStack(alignment: .leading, spacing: 4) { Eyebrow(text: "Your membership"); Text("\(store.tier) Buddy").font(.system(size: 22, weight: .bold, design: .rounded)).foregroundStyle(ABColor.ink) }; Spacer(); Image(systemName: "medal.fill").font(.system(size: 28)).foregroundStyle(Color(red: 0.85, green: 0.63, blue: 0.27)) }
                        HStack(alignment: .firstTextBaseline, spacing: 5) { Text("\(store.data.points)").font(.system(size: 30, weight: .bold, design: .rounded)); Text("points").font(.system(size: 13, weight: .medium)) }.foregroundStyle(ABColor.ink)
                        ProgressView(value: progress).tint(ABColor.green).scaleEffect(x: 1, y: 1.4, anchor: .center)
                        Text("\(max(0, store.nextTierPoints - store.data.points)) points to your next reward").font(.system(size: 12)).foregroundStyle(ABColor.muted)
                    }.padding(18).background(.white, in: RoundedRectangle(cornerRadius: 20))
                    VStack(alignment: .leading, spacing: 14) { SectionTitle(title: "Your buddy"); HStack(spacing: 12) { Avatar(initial: "J", color: ABColor.peach, size: 46); VStack(alignment: .leading, spacing: 4) { Text("Jamie").font(.system(size: 15, weight: .bold, design: .rounded)).foregroundStyle(ABColor.ink); Text("\(store.data.workStyle) · matched today").font(.system(size: 11)).foregroundStyle(ABColor.muted) }; Spacer(); Image(systemName: "checkmark.seal.fill").foregroundStyle(ABColor.green) }.padding(14).background(.white, in: RoundedRectangle(cornerRadius: 18)) }
                    VStack(alignment: .leading, spacing: 12) { SectionTitle(title: "Your weekly wins"); HStack(spacing: 10) { StatCard(value: "\(store.completedCount)", label: "goals done", icon: "checkmark", tint: ABColor.mint); StatCard(value: "\(store.data.points)", label: "points earned", icon: "sparkle", tint: ABColor.peach) } }
                    Button(action: onFindBuddy) { Label("Your matching preferences", systemImage: "slider.horizontal.3").font(.system(size: 14, weight: .semibold)).foregroundStyle(ABColor.ink).frame(maxWidth: .infinity).padding(16).background(.white, in: RoundedRectangle(cornerRadius: 16)) }
                    Text("AccountaBuddy · a little progress, together").font(.system(size: 11)).foregroundStyle(ABColor.muted).padding(.top, 3)
                }.padding(20)
            }.abPage().toolbar(.hidden, for: .navigationBar)
        }
    }
}
