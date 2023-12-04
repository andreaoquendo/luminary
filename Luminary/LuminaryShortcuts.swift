import AppIntents

struct LuminaryShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: QuoteIntent(),
            phrases: [
                "Save a quote",
                "Save a quote on Lumy",
            ],
            shortTitle: "Save quote",
            systemImageName: "arrow.up.circle.fill"
        )
    }
}
