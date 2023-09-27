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
        let newQuote = Quote(context: viewContext)
        newQuote.quote = quote
        newQuote.author = author
        newQuote.date = date
        newQuote.outro = outro

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
}


struct AddQuoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddQuoteView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
