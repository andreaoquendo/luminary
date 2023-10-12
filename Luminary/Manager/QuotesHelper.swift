import Foundation

struct QuoteItem {
    let quote: String
    let date: Date
}

class QuotesHelper {
    static let sharedContainer = UserDefaults(suiteName: "group.mainlumy")

    static func storeRandomQuote(quote: String, date: Date) {
        let dictionary: [String: Any] = [
            "quote": quote,
            "date": date
        ]
        sharedContainer?.set(dictionary, forKey: "RandomQuoteItem")
    }
    
    static func updateRandomQuote(){
        func isNewDay() -> Bool {
            if let storedDate = getQuoteDate() {
                let currentDate = Date()
                let calendar = Calendar.current
                return !calendar.isDate(storedDate, inSameDayAs: currentDate)
            }
            return true
        }
        
        func generateNewRandomIndex() -> Int {
            if quotes.count == 0 {
                return -1
            }
            
            let randomIndex = Int.random(in: 0..<quotes.count) // Adjust this range accordingly
            storeQuoteIndex(randomIndex, forDate: Date())
            return randomIndex
        }
        
        if isNewDay() == false { return }
        
        let quotes = CoreData.shared.getStoredDataFromCoreData()
        
        let newIndex = generateNewRandomIndex()
        let q = quotes[quotes.count - newIndex - 1]
        
        
        storeRandomQuote(quote: q.quote ?? "", date: q.date ?? Date())

    }

    static func getRandomQuote() -> QuoteItem? {
        updateRandomQuote()
        
        if let dictionary = sharedContainer?.dictionary(forKey: "RandomQuoteItem"),
           let quote = dictionary["quote"] as? String,
           let date = dictionary["date"] as? Date {
            return QuoteItem(quote: quote, date: date)
        }
        return nil
    }
    
    static func addQuote(quote: String, date: Date) {
            // Get existing items
        var items = getQuotes()
        
        let quoteItem = QuoteItem(quote: quote, date: date)
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
    
    static func storeQuoteIndex(_ index: Int, forDate date: Date) {
        sharedContainer?.set(index, forKey: "QuoteIndex")
        sharedContainer?.set(date, forKey: "QuoteDate")
    }

    static func getSavedIndex() -> Int? {
        return sharedContainer?.integer(forKey: "QuoteIndex")
    }

    static func getQuoteDate() -> Date? {
        return sharedContainer?.object(forKey: "QuoteDate") as? Date
    }
    
   
}
