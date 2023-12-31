//
//  QuoteIntent.swift
//  Luminary
//
//  Created by Andrea Oquendo on 29/09/23.
//

import Foundation
import AppIntents

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct QuoteIntent: AppIntent, CustomIntentMigratedAppIntent, PredictableIntent {
    static let intentClassName = "QuoteIntentIntent"

    static var title: LocalizedStringResource = "Quote Intent"
    static var description = IntentDescription("Create a quote")

    @Parameter(title: "Quote", requestValueDialog: "Which quote would you like to add?")
    var quote: String

    static var parameterSummary: some ParameterSummary {
        Summary("Let's add a quote?") {
            \.$quote
        }
    }

    static var predictionConfiguration: some IntentPredictionConfiguration {
        IntentPrediction(parameters: (\.$quote)) { quote in
            DisplayRepresentation(
                title: "Add Quote",
                subtitle: "Add a quote to your library in Lumy!"
            )
        }
    }

    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        QuotesHelper.addQuote(quote: quote, date: Date())
        
        
        return .result(value: String("Here's a test"))
    }
}

fileprivate extension IntentDialog {
    static var quoteParameterPrompt: Self {
        "What quote would you like to add?"
    }
    static func responseSuccess(quote: String) -> Self {
        "The quote was added to your library."
    }
    static var responseFailure: Self {
        "Sorry, the quote was not able to make it."
    }
}

