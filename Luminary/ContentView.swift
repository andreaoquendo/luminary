//
//  ContentView.swift
//  Luminary
//
//  Created by Andrea Oquendo on 25/09/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \Quote.quote, ascending: true)],
        animation: .default)
    var quotes: FetchedResults<Quote>
    

    var body: some View {
        NavigationView {
            List {
                ForEach(quotes) { quote in
                    NavigationLink {
                        Text(quote.quote ?? "placeholder")
                    } label: {
                        Text(quote.quote ?? "placeholder")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: AddQuoteView()) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
            }
            Text("Select an item")
        }
        .navigationTitle("My Quotes")
        .navigationBarTitleDisplayMode(.large)
        
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
