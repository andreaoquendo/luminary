import Foundation

struct QuoteItem {
    let quote: String
    let date: Date
}

class QuotesHelper {
    static let sharedContainer = UserDefaults(suiteName: "group.mainlumy")

//    static func addQuote(quote: String, date: Date) {
//        var quotes = sharedContainer?.stringArray(forKey: "standByQuotes") ?? []
//        quotes.append(quote)
//        sharedContainer?.set(quotes, forKey: "standByQuotes")
//    }
    
    static func addQuote(quote: String, date: Date) {
            // Get existing items
        var items = getQuotes()
        
        var quoteItem = QuoteItem(quote: quote, date: date)
        // Add the new item
        items.append(quoteItem)
        
        // Convert items to a format that can be stored in UserDefaults
        let itemData = items.map { ["quote": $0.quote, "date": $0.date] }
        
        // Store the items in UserDefaults
        sharedContainer?.set(itemData, forKey: "standByQuotes")
    }

    static func reset() {
        sharedContainer?.removeObject(forKey: "standByQuotes")
    }

//    static func getQuotes() -> [String] {
//        return sharedContainer?.stringArray(forKey: "standByQuotes") ?? []
//    }
    static func getQuotes() -> [QuoteItem] {
            if let itemData = sharedContainer?.array(forKey: "standByQuotes") as? [[String: Any]] {
                let items = itemData.compactMap {
                    if let quote = $0["quote"] as? String, let date = $0["date"] as? Date {
                        return QuoteItem(quote: quote, date: date)
                    }
                    return nil
                }
                return items
            }
            return []
        }
}
