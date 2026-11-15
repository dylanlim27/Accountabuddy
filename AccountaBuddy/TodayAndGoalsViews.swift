import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: BuddyStore
    let onChat: () -> Void
    @State private var showAdd = false
    private var greeting: String { Calendar.current.component(.hour, from: .now) < 12 ? "Good morning" : "Good to see you" }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 23) {
                    HStack { VStack(alignment: .leading, spacing: 5) { Eyebrow(text: Date.now.formatted(.dateTime.weekday(.wide).month(.wide).day()).uppercased()); Text("\(greeting), \(store.data.name)").font(.system(size: 27, weight: .bold, design: .rounded)).foregroundStyle(ABColor.ink) }; Spacer(); Avatar(initial: String(store.data.name.prefix(1)), size: 44) }
                    HStack(spacing: 14) {
                        Avatar(initial: "J", color: ABColor.peach, size: 48)
                        VStack(alignment: .leading, spacing: 3) { Text("Jamie is in your corner").font(.system(size: 15, weight: .bold, design: .rounded)).foregroundStyle(ABColor.ink); Text("Last seen just now").font(.system(size: 12)).foregroundStyle(ABColor.muted) }
                        Spacer()
                        Button(action: onChat) { Image(systemName: "bubble.left.fill").font(.system(size: 15)).foregroundStyle(.white).frame(width: 40, height: 40).background(ABColor.green, in: Circle()) }
                    }.padding(15).background(.white, in: RoundedRectangle(cornerRadius: 20))
                    HStack(spacing: 11) {
                        StatCard(value: "\(store.openGoals.count)", label: "in progress", icon: "scope", tint: ABColor.mint)
                        StatCard(value: "\(store.completedCount)", label: "done together", icon: "checkmark", tint: ABColor.peach)
                        StatCard(value: "\(store.data.points)", label: "buddy points", icon: "sparkle", tint: Color(red: 0.88, green: 0.86, blue: 0.97))
                    }
                    HStack(spacing: 13) {
                        Image(systemName: "quote.opening").font(.system(size: 17, weight: .bold)).foregroundStyle(ABColor.green)
                        Text("Small steps still move you forward.").font(.system(size: 14, weight: .semibold, design: .rounded)).foregroundStyle(ABColor.ink)
                        Spacer(minLength: 0); Text("JAMIE").font(.system(size: 9, weight: .bold)).tracking(1).foregroundStyle(ABColor.muted)
                    }.padding(16).background(ABColor.mint.opacity(0.55), in: RoundedRectangle(cornerRadius: 17))
                    SectionTitle(title: "Your next steps", action: { showAdd = true }, actionTitle: "+ Add a goal")
                    VStack(spacing: 0) {
                        ForEach(Array(store.openGoals.prefix(3))) { goal in GoalRow(goal: goal, onToggle: { store.toggleGoal(goal) }) }
                        if store.openGoals.isEmpty { Text("A fresh page. Add a goal when you’re ready.").font(.system(size: 14)).foregroundStyle(ABColor.muted).padding(20).frame(maxWidth: .infinity, alignment: .leading) }
                    }.padding(.horizontal, 15).background(.white, in: RoundedRectangle(cornerRadius: 20))
                    SectionTitle(title: "Jamie’s goal")
                    HStack(spacing: 13) {
                        Image(systemName: "doc.text").foregroundStyle(ABColor.green).frame(width: 42, height: 42).background(ABColor.mint.opacity(0.55), in: RoundedRectangle(cornerRadius: 13))
                        VStack(alignment: .leading, spacing: 5) { Text("Send the first draft").font(.system(size: 14, weight: .semibold, design: .rounded)).foregroundStyle(ABColor.ink); Text("Due \(Calendar.current.date(byAdding: .day, value: 3, to: .now)!.formatted(.dateTime.weekday(.wide)))").font(.system(size: 12)).foregroundStyle(ABColor.muted) }
                        Spacer(); Text("IN PROGRESS").font(.system(size: 9, weight: .bold)).tracking(0.7).foregroundStyle(ABColor.green).padding(.horizontal, 9).padding(.vertical, 6).background(ABColor.mint.opacity(0.55), in: Capsule())
                    }.padding(14).background(.white, in: RoundedRectangle(cornerRadius: 18))
                    Text("Demo experience · Jamie is a sample buddy").font(.system(size: 11)).foregroundStyle(ABColor.muted).frame(maxWidth: .infinity).padding(.top, 3)
                }.padding(20)
            }.abPage().toolbar(.hidden, for: .navigationBar).sheet(isPresented: $showAdd) { AddGoalView() }
        }
    }
}

struct StatCard: View {
    let value: String; let label: String; let icon: String; let tint: Color
    var body: some View { VStack(alignment: .leading, spacing: 9) { Image(systemName: icon).font(.system(size: 13, weight: .semibold)).foregroundStyle(ABColor.ink).frame(width: 26, height: 26).background(tint, in: RoundedRectangle(cornerRadius: 9)); Text(value).font(.system(size: 22, weight: .bold, design: .rounded)).foregroundStyle(ABColor.ink); Text(label).font(.system(size: 10, weight: .medium)).foregroundStyle(ABColor.muted).lineLimit(1).minimumScaleFactor(0.75) }.frame(maxWidth: .infinity, alignment: .leading).padding(12).background(.white, in: RoundedRectangle(cornerRadius: 16)) }
}

struct GoalRow: View {
    @EnvironmentObject private var store: BuddyStore
    let goal: Goal
    let onToggle: () -> Void
    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) { Image(systemName: goal.isComplete ? "checkmark.circle.fill" : "circle").font(.system(size: 22)).foregroundStyle(goal.isComplete ? ABColor.green : ABColor.muted.opacity(0.5)) }.buttonStyle(.plain)
            VStack(alignment: .leading, spacing: 5) { Text(goal.title).font(.system(size: 14, weight: .semibold, design: .rounded)).foregroundStyle(ABColor.ink).strikethrough(goal.isComplete); Text("\(goal.isBuddyGoal ? "For Jamie" : "Due") · \(goal.dueDate.formatted(.dateTime.weekday(.wide)))").font(.system(size: 11)).foregroundStyle(ABColor.muted) }
            Spacer(minLength: 4); Text("+\(goal.isBuddyGoal ? 10 : 20)").font(.system(size: 11, weight: .bold, design: .rounded)).foregroundStyle(ABColor.green).padding(.horizontal, 8).padding(.vertical, 6).background(ABColor.mint.opacity(0.5), in: Capsule())
        }.padding(.vertical, 13).overlay(alignment: .bottom) { Rectangle().fill(ABColor.paper).frame(height: 1).padding(.leading, 34) }
    }
}

struct GoalsView: View {
    @EnvironmentObject private var store: BuddyStore
    @State private var showAdd = false
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    VStack(alignment: .leading, spacing: 6) { Eyebrow(text: "One step at a time"); Text("Your goals").font(.system(size: 30, weight: .bold, design: .rounded)).foregroundStyle(ABColor.ink) }
                    HStack(spacing: 12) { Image(systemName: "person.2.fill").foregroundStyle(ABColor.green); Text("Jamie can see the goals you share here.").font(.system(size: 13, weight: .medium)).foregroundStyle(ABColor.ink) }.padding(15).frame(maxWidth: .infinity, alignment: .leading).background(ABColor.mint.opacity(0.55), in: RoundedRectangle(cornerRadius: 17))
                    SectionTitle(title: "In progress", action: { showAdd = true }, actionTitle: "+ Add goal")
                    VStack(spacing: 0) { ForEach(store.openGoals) { goal in GoalRow(goal: goal, onToggle: { store.toggleGoal(goal) }) }; if store.openGoals.isEmpty { Text("No open goals right now. Make space for a new one.").font(.system(size: 14)).foregroundStyle(ABColor.muted).padding(18) } }.padding(.horizontal, 15).background(.white, in: RoundedRectangle(cornerRadius: 20))
                    SectionTitle(title: "Done")
                    VStack(spacing: 0) { ForEach(store.data.goals.filter(\.isComplete)) { goal in GoalRow(goal: goal, onToggle: { store.toggleGoal(goal) }) }; if store.completedCount == 0 { Text("Your wins will show up here.").font(.system(size: 14)).foregroundStyle(ABColor.muted).padding(18) } }.padding(.horizontal, 15).background(.white, in: RoundedRectangle(cornerRadius: 20))
                    Text("Complete a goal to earn buddy points — Jamie gets a little celebration too.").font(.system(size: 13)).foregroundStyle(ABColor.muted).lineSpacing(3).padding(.horizontal, 2)
                }.padding(20)
            }.abPage().toolbar(.hidden, for: .navigationBar).sheet(isPresented: $showAdd) { AddGoalView() }
        }
    }
}

struct AddGoalView: View {
    @EnvironmentObject private var store: BuddyStore
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var dueDate = Calendar.current.date(byAdding: .day, value: 1, to: .now) ?? .now
    var body: some View {
        NavigationStack {
            Form { Section("What do you want to do?") { TextField("e.g. Draft the introduction", text: $title) }; Section("When will you do it?") { DatePicker("Due date", selection: $dueDate, in: Date.now..., displayedComponents: .date) }; Section { Label("Complete it for +20 points", systemImage: "sparkle").foregroundStyle(ABColor.green) } }
                .navigationTitle("New goal").navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }; ToolbarItem(placement: .confirmationAction) { Button("Add") { store.addGoal(title, dueDate: dueDate); dismiss() }.disabled(title.trimmingCharacters(in: .whitespaces).isEmpty) } }
        }.presentationDetents([.medium, .large]).presentationDragIndicator(.visible)
    }
}
