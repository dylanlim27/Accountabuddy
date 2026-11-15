import Foundation

struct Goal: Identifiable, Codable {
    var id = UUID()
    var title: String
    var dueDate: Date
    var isComplete = false
    var isBuddyGoal = false
}

struct Message: Identifiable, Codable {
    var id = UUID()
    var text: String
    var fromBuddy: Bool
    var sentAt = Date()
}

struct BuddyStoreData: Codable {
    var name = "Alex"
    var focus = "Study & learning"
    var workStyle = "Gentle encouragement"
    var points = 120
    var encouragedBuddy = false
    var goals: [Goal] = [
        Goal(title: "Finish my project outline", dueDate: Calendar.current.date(byAdding: .day, value: 1, to: .now) ?? .now),
        Goal(title: "Read for 30 minutes", dueDate: Calendar.current.date(byAdding: .day, value: 2, to: .now) ?? .now),
        Goal(title: "Send the first draft", dueDate: Calendar.current.date(byAdding: .day, value: 3, to: .now) ?? .now, isBuddyGoal: true)
    ]
    var messages: [Message] = [
        Message(text: "Hey! What’s the one thing you’d love to get done today?", fromBuddy: true),
        Message(text: "I’m getting my project outline finished 🙌", fromBuddy: false),
        Message(text: "You’ve got this. I’ll check in later!", fromBuddy: true)
    ]
}

@MainActor
final class BuddyStore: ObservableObject {
    @Published var data: BuddyStoreData { didSet { save() } }
    @Published var hasOnboarded = UserDefaults.standard.bool(forKey: "accountabuddy.onboarded")

    init() {
        if let saved = UserDefaults.standard.data(forKey: "accountabuddy.data"),
           let decoded = try? JSONDecoder().decode(BuddyStoreData.self, from: saved) {
            data = decoded
        } else {
            data = BuddyStoreData()
        }
    }

    var openGoals: [Goal] { data.goals.filter { !$0.isComplete } }
    var completedCount: Int { data.goals.filter(\.isComplete).count }
    var tier: String { data.points >= 500 ? "Gold" : data.points >= 200 ? "Silver" : "Bronze" }
    var nextTierPoints: Int { data.points >= 500 ? 700 : data.points >= 200 ? 500 : 200 }

    func addGoal(_ title: String, dueDate: Date) {
        let clean = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !clean.isEmpty else { return }
        data.goals.insert(Goal(title: clean, dueDate: dueDate), at: 0)
    }

    func toggleGoal(_ goal: Goal) {
        guard let index = data.goals.firstIndex(where: { $0.id == goal.id }) else { return }
        data.goals[index].isComplete.toggle()
        if data.goals[index].isComplete { data.points += goal.isBuddyGoal ? 10 : 20 }
    }

    func send(_ text: String) {
        let clean = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !clean.isEmpty else { return }
        data.messages.append(Message(text: clean, fromBuddy: false))
    }

    func encourageBuddy() {
        guard !data.encouragedBuddy else { return }
        data.encouragedBuddy = true
        data.points += 10
        data.messages.append(Message(text: "You’ve got this, Jamie! One small step at a time 💪", fromBuddy: false))
    }

    func finishOnboarding(name: String, focus: String, style: String) {
        data.name = name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Alex" : name
        data.focus = focus
        data.workStyle = style
        hasOnboarded = true
        UserDefaults.standard.set(true, forKey: "accountabuddy.onboarded")
    }

    private func save() {
        guard let encoded = try? JSONEncoder().encode(data) else { return }
        UserDefaults.standard.set(encoded, forKey: "accountabuddy.data")
    }
}
