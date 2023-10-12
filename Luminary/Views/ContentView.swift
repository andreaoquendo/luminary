//
//  ContentView.swift
//  Luminary
//
//  Created by Andrea Oquendo on 25/09/23.
//

import SwiftUI
import CoreData
import Combine
import WidgetKit


struct DropCapTextView: View {
    let text: String
    @State var aux: Int = 70

    var body: some View {
        VStack(alignment: .leading, spacing: -4) {
            HStack(alignment: .center, spacing: 10){
                Text(text.prefix(1))
                    .font(.dropCapFirstLetter)
                    .frame(width:42, height: 70)
                GeometryReader { geometry in
                    HStack(alignment: .center){
                        Text(textWithCaps())
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .background(
                                Color.clear.onAppear {
                                    // Calculate the number of characters that fit on one line
                                    let maxWidth = geometry.size.width
                                    let font = UIFont(name: "Baskervville-Regular", size: 22)
                                    let approximateCharactersPerLine = Int(maxWidth / (font?.pointSize ?? 1))
                                    aux = approximateCharactersPerLine * 5 - 8
                                    
                                }
                            )
                    }
                    .frame(maxHeight: .infinity)
                    .padding(0)
                        
                }
                .frame(height:70)
            }
            Text(textWithoutCaps())
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .font(.dropCapText)
    }

    private func textWithCaps() -> String {
        
        if text.count > aux {
            let t = String(text.dropFirst().prefix(aux).last ?? " ")
            
            if t == " " {
                return String(text.dropFirst().prefix(aux - 1))
            } else {
                let word = text.dropFirst().prefix(aux)
                let a = Array(word).reversed()
                var idx = aux
                
                for (index, item) in a.enumerated() {
                    if item == " " {
                        idx = aux - index
                        break
                    }
                }
                
                return String(text.dropFirst().prefix(idx).trimmingCharacters(in: .whitespacesAndNewlines))
              
            }
        }
        
        
        return String(text.dropFirst().trimmingCharacters(in: .whitespacesAndNewlines))
        
    }
    
    
    private func textWithoutCaps() -> String{
        if text.count > aux {
            let t = String(text.dropFirst().prefix(aux).last ?? " ")
            if t == " " {
                return String(text.dropFirst(aux)).trim()
            } else {
                let word = text.dropFirst().prefix(aux)
                let a = Array(word).reversed()
                var idx = aux
                
                for (index, item) in a.enumerated() {
                    if item == " " {
                        idx = aux - index
                        break
                    }
                }
                
                return String(text.dropFirst(idx)).trim()
                
            }
        }
        
        
        return ""
    }

}


struct ContentView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.scenePhase) var scenePhase
    
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \Quote.date, ascending: false)],
        animation: .default)
    var quotes: FetchedResults<Quote>
    

    var body: some View {
        NavigationView {
            VStack{
                
                // Quote of the Day
                VStack(spacing:8){
                    VStack(alignment: .leading, spacing: 8){
                        Text("quote of the day")
                            .font(.appTitle)
                        Line()
                    }
                    
                    
                    VStack(spacing: 16){
                        DropCapTextView(text: getTodaysQuote()?.quote ?? "There is no quote registered.")
                        
                        Text(todaysQuoteSub())
                            .font(.appBody)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        
                    }
                    .padding(.vertical, 64)
                }
                
                Spacer()
                
                VStack(spacing: 16){
        
                    VStack(alignment: .leading, spacing:8){
                        HStack(){
                            Text("your quotes")
                                .foregroundColor(.textLuminary)
                                .font(.appTitle)

                            Spacer()

                            NavigationLink(destination: AddQuoteView()) {
                                Label("Add quote", systemImage: "plus")
                                    .labelStyle(.iconOnly)
                                    .foregroundColor(.textLuminary)
                            }

                        }

                        Line()
                    }
                    
                    ScrollView(){
                        VStack(spacing: 16){
                            ForEach(quotes) { quote in
                                
                                NavigationLink {
                                    EditQuoteView(editedQuote: quote)

                                } label: {
                                    QuoteItem(
                                        quote: quote.quote!,
                                        author: quote.author,
                                        outro: quote.outro
                                    )
                                }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)

                }
                

                
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.primaryLuminary)
            .foregroundColor(.textLuminary)
            
        }
        .background(Color.primaryLuminary)
        .onAppear {
            firstLaunch()
        }
        .onChange(of: scenePhase) { newPhase in
            
            if newPhase == .active {
                if !QuotesHelper.getQuotes().isEmpty {
                    for quote in QuotesHelper.getQuotes() {
                        addQuote(quote: quote.quote, date: quote.date)
                    }
                    QuotesHelper.reset()
                }
                
            }
            else {
                WidgetCenter.shared.reloadAllTimelines()
            }
            
        }

    }
    
    private func firstLaunch() {
        let isFirstLaunch: Bool = !UserDefaults.standard.bool(forKey: "isFirstLaunch")
        
        if isFirstLaunch {
            addPreviewQuote(quote: "Growing old and dying is what gives meaning and beauty to the fleeting span of life. It's precisely because we age and die that our lives have value and nobility.", author: "Rengoku", outro: "Demon Slayer")
            addPreviewQuote(quote: "A sound soul dwells within a sound mind & a sound body.", author: "Maka", outro: "Soul Eater")
            addPreviewQuote(quote: "You should use your strength to help others.", author: "Itadori's Grandfather", outro: "Jujutsu Kaisen")
            addPreviewQuote(quote: "It’s not about whether I can, I have to do it.", author: "Megumi Fushiguro", outro: "Jujutsu Kaisen")
            addPreviewQuote(quote: "Dedication is a talent all on its own.", author: "Alphonse", outro: "Fullmetal Alchemist Brotherhood")
            
        }
    }
    
    private func todaysQuoteSub() -> String {
        
        var text = ""
        
        if let quote = getTodaysQuote() {
            if let author = quote.author {
                if !author.isEmpty {
                    text += "— \(author)"
                    
                    if let outro = quote.outro {
                        if !outro.isEmpty {
                            text += " (\(outro))"
                        }
                    }
                } else {
                    if let outro = quote.outro {
                        if !outro.isEmpty {
                            text += "(\(outro))"
                        }
                    }
                }
            }
            
        }
        
        return text
    }
    
    func generateNewRandomIndex() -> Int {
        if quotes.count == 0 {
            return -1
        }
        
        let randomIndex = Int.random(in: 0..<quotes.count) // Adjust this range accordingly
        QuotesHelper.storeQuoteIndex(randomIndex, forDate: Date())
        return randomIndex
    }
    
    func getTodaysQuote() -> Quote? {
        
        // If it's empty, there's no quote to show
        if quotes.isEmpty {
            return nil
        }
        
        // Prevent if the user has deleted too much quotes
        if let savedIndex = QuotesHelper.getSavedIndex() {
            if savedIndex >= quotes.count {
                _ = generateNewRandomIndex()
            }
        }

        
        if isNewDay() {
            let randomIndex = generateNewRandomIndex()
            // Use this randomIndex to fetch the quote
            if randomIndex == -1 {
                return nil
            }
            
            let q = quotes[quotes.count - randomIndex - 1]
            QuotesHelper.storeRandomQuote(quote: q.quote ?? "", date: q.date ?? Date())
            return q
        }
        
        if QuotesHelper.getSavedIndex() == nil {
            return nil
        }
        let val = quotes.count - (QuotesHelper.getSavedIndex() ?? 0) - 1
        
        let q = quotes[val]
        QuotesHelper.storeRandomQuote(quote: q.quote ?? "", date: q.date ?? Date())
        return q
    }
    
    func isNewDay() -> Bool {
        if let storedDate = QuotesHelper.getQuoteDate() {
            let currentDate = Date()
            let calendar = Calendar.current
            return !calendar.isDate(storedDate, inSameDayAs: currentDate)
        }
        return true
    }

    private func addPreviewQuote(quote: String, author: String, outro: String) {
        
        /* TO-DO */
        
        let newQuote = Quote(context: CoreData.shared.persistentContainer.viewContext)
        newQuote.quote = quote
        newQuote.author = author
        newQuote.date = Date()
        newQuote.outro = outro

        CoreData.shared.saveContext()
        
  
    }
    
    private func addQuote(quote: String, date: Date) {
        CoreData.shared.saveQuote(quote: quote, date: date)
    }

    private func Line () -> some View {
        Rectangle()
            .frame(maxWidth: .infinity)
            .frame(height:1)
            .background(.white)
    }
    
    private func quoteItemText(author: String?, outro: String?) -> String {
        
        var text = ""
        
        if let localAuthor = author, !localAuthor.isEmpty  {
              text += "— \(localAuthor) "
        }
        
        if let localOutro = outro, !localOutro.isEmpty {
            text += "(\(localOutro))"
        }
        
        return text.trim()
    }
    
    private func QuoteItem(quote: String, author: String?, outro: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text(quote)
                .font(.appBody)
            
            if !quoteItemText(author: author, outro: outro).isEmpty{
                Text(quoteItemText(author: author, outro: outro))
                    .font(.appQuoteSubtitle)
            }
            
        }
        .padding(16)
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.fadedLuminary)
        .foregroundColor(.textLuminary)
        .cornerRadius(4)
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
