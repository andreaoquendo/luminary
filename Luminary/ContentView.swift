//
//  ContentView.swift
//  Luminary
//
//  Created by Andrea Oquendo on 25/09/23.
//

import SwiftUI
import CoreData

struct DropCapTextView: View {
    let text: String
    var aux: Int = 70

    var body: some View {
        VStack(alignment: .leading, spacing: -4) {
            HStack(alignment: .center, spacing: 10){
                Text(text.prefix(1))
                    .font(Font.custom("DMSerifDisplay-Regular", size: 64))
                    .frame(width:42, height: 70)
                Text(textWithCaps())
                    .fixedSize(horizontal: false, vertical: true)
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
                    print(item)
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
                    print(item)
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
    @Environment(\.managedObjectContext) private var viewContext
    
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
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { quotes[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
