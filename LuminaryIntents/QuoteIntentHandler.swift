import Foundation
import Intents
import CoreData


class QuoteIntentHandler: NSObject, QuoteIntentIntentHandling {
    
    func resolveQuote(for intent: QuoteIntentIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if let quote = intent.quote, !quote.isEmpty {
            completion(.success(with: quote))
        } else {
            completion(.needsValue())
        }
    }
    
    
    func handle(intent: QuoteIntentIntent, completion: @escaping (QuoteIntentIntentResponse) -> Void) {
        let response: QuoteIntentIntentResponse
        
        if let quote = intent.quote {
            
            response = .success(quote: quote)
            QuotesHelper.addQuote(quote: quote, date: Date())
        } else {
            response = .success(quote: "Example Quote")
        }
        
        completion(response)
    }

    
}
