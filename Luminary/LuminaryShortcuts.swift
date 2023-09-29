import AppIntents

struct LuminaryShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: QuoteIntent(),
            phrases: [
                "Save a quote",
                "Save a quote on Lumy",
            ]
        )
    }
}
