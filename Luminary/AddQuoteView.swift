//
//  AddQuoteView.swift
//  Luminary
//
//  Created by Andrea Oquendo on 25/09/23.
//

import SwiftUI

struct AddQuoteView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var quote = ""
    @State private var date = Date()
    @State private var author = ""
    @State private var outro = ""
    
    var body: some View {
        Form {
            Section(header: Text("Quote Details")) {
                TextField("Quote", text: $quote)
                TextField("Author", text: $author)
                TextField("Outro", text: $outro)
                DatePicker("Data", selection: $date, displayedComponents: .date)
            }
            
            Button(action: addQuote) {
                Text("Adicionar Frase")
            }
        }
        .navigationBarTitle("Add Quote")
    }
    
    private func addQuote() {
        let newQuote = Quote(context: CoreData.shared.persistentContainer.viewContext)
        newQuote.quote = quote
        newQuote.author = author
        newQuote.date = date
        newQuote.outro = outro
        print(newQuote)

        CoreData.shared.saveContext()
        presentationMode.wrappedValue.dismiss()
        
  
    }
    
}


struct AddQuoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddQuoteView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
