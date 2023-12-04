import AppIntents

struct LuminaryShortcuts: AppShortcutsProvider {
    @AppShortcutsBuilder static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: QuoteIntent(),
            phrases: [
                "Save a quote",
                "Save a quote on \(.applicationName)",
            ],
            shortTitle: "Save quote",
            systemImageName: "square.and.pencil"
        )
    }
}
