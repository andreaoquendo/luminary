//
//  ContentView.swift
//  Luminary
//
//  Created by Andrea Oquendo on 25/09/23.
//

import SwiftUI
import CoreData
import Combine


struct DropCapTextView: View {
    let text: String
    @State var aux: Int = 70

    var body: some View {
        VStack(alignment: .leading, spacing: -4) {
            HStack(alignment: .center, spacing: 10){
                Text(text.prefix(1))
                    .font(Font.custom("DMSerifDisplay-Regular", size: 64))
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
                                    let font = UIFont(name: "Baskervville-Regular", size: 22) // Change to your desired font
                                    
                                    // Calculate the approximate number of characters that fit in one line
                                    let approximateCharactersPerLine = Int(maxWidth / (font?.pointSize ?? 1))
                                    aux = approximateCharactersPerLine * 5 - 8
                                    
                                    print("Approximate characters per line: \(approximateCharactersPerLine)")
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
        .font(Font.custom("Baskervville-Regular", size: 22))
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
                
                return String(text.dropFirst().prefix(idx))
              
            }
        }
        
        
        return text
        
    }
    
    private func textWithoutCaps() -> String{
        if text.count > aux {
            let t = String(text.dropFirst().prefix(aux).last ?? " ")
            if t == " " {
                return String(text.dropFirst(aux).trimmingCharacters(in: .whitespacesAndNewlines))
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
                
                return String(text.dropFirst(idx).trimmingCharacters(in: .whitespacesAndNewlines))
                
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
    
    @State private var viewDidLoad = false
    

    

    var body: some View {
        NavigationView {
            VStack{
                // Quote of the Day
                VStack(spacing:8){
                    VStack(alignment: .leading, spacing: 8){
                        Text("quote of the day")
                            .font(Font.custom("DMSerifDisplay-Regular", size: 24))
                        Line()
                    }
                    
                    
                    VStack(spacing: 16){
                        DropCapTextView(text: "Growing old and dying is what gives meaning and beauty to the fleeting span of a human life. It’s precisely because we age and die that our lives have value and nobility.")
                        
                        Text("— Kyojuro Rengoku (Demon Slayer)")
                            .font(Font.custom("Baskervville-Regular", size: 16))
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
                                .font(Font.custom("DMSerifDisplay-Regular", size: 24))

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
                                    Text(quote.quote ?? "placeholder")
                                } label: {
                                    QuoteItem(
                                        quote: quote.quote,
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
        
            if viewDidLoad == false {
                viewDidLoad = true
                AppIntent.allowSiri()
                AppIntent.quoteSiri()
            }
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
            
        }

    }
    
    private func addQuote(quote: String, date: Date) {
        let newQuote = Quote(context: CoreData.shared.persistentContainer.viewContext)
        newQuote.quote = quote
        newQuote.author = "Unknown"
        newQuote.date = date
        newQuote.outro = ""

        CoreData.shared.saveContext()
        
  
    }

    private func Line () -> some View {
        Rectangle()
            .frame(maxWidth: .infinity)
            .frame(height:1)
            .background(.white)
    }
    
    private func QuoteItem(quote: String? = "", author: String? = "", outro: String? = "") -> some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text(quote ?? "")
            
            if outro?.count ?? 0 > 0 {
                Text("— \(author ?? "Unknown") (\(outro ?? ""))")
            } else {
                Text("— \(author ?? "Unknown")")
            }
        }
        .font(Font.custom("Baskervville-Regular", size: 16))
        .padding(16)
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .multilineTextAlignment(.leading)
        .background(Color.fadedLuminary)
        .cornerRadius(4)
        .foregroundColor(.textLuminary)
        
    }
    
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { quotes[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
