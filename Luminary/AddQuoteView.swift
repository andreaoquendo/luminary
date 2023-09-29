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
        VStack(alignment: .leading, spacing: 10){
            
            VStack(alignment: .leading, spacing: 8){
                ZStack{
                    HStack(){
                        Spacer()
                        Text("add quote")
                            .font(Font.custom("DMSerifDisplay-Regular", size: 24))
                        Spacer()
                    }
                    HStack(){
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "arrow.left")
                                .font(Font.custom("SF Pro", size: 24).weight(.thin))
                                .foregroundColor(Color.textLuminary)
                        }
                        Spacer()
                    }
                }
                
                Line()
            }
            
            VStack(){
                VStack(alignment: .leading, spacing:10){
                    Text("Quote:")
                    TextEditor(text: $quote)
                        .scrollContentBackground(.hidden) // <- Hide it
                        .background(.clear)
                        .font(Font.custom("Baskervville-Regular", size: 16))
                        .padding(4)
                        .frame(width: 342, height: 100, alignment: .leading)
                        .background(Color.fadedLuminary)
                        .cornerRadius(4)
                }
                .font(Font.custom("Baskervville-Regular", size: 16))
                
                VStack(alignment: .leading, spacing:10){
                    Text("Author:")
                    TextField("Author", text: $author)
                        .font(Font.custom("Baskervville-Regular", size: 16))
                        .padding(8)
                        .background(Color.fadedLuminary)
                        .cornerRadius(4)
                }
                .font(Font.custom("Baskervville-Regular", size: 16))
                
                VStack(alignment: .leading, spacing:10){
                    Text("Origin:")
                    TextField("Book of Tales", text: $outro)
                        .font(Font.custom("Baskervville-Regular", size: 16))
                        .padding(8)
                        .background(Color.fadedLuminary)
                        .cornerRadius(4)
                }
                .font(Font.custom("Baskervville-Regular", size: 16))
            }
            .padding(.vertical, 10)
            
            
            HStack{
                
                Spacer()
                
                Button(action: addQuote) {
                    Text("Add Quote")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .font(Font.custom("Baskervville-Regular", size: 16))
                        .background(.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .inset(by: 0.5)
                                .stroke(Color.textLuminary, lineWidth: 1)
                        )
                }
            }
            .padding(.top, 16)
            .background(.clear)
            
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        
        .background(Color.primaryLuminary)
        .foregroundColor(Color.textLuminary)
        .navigationBarBackButtonHidden(true)
    }
    
    private func Line () -> some View {
        Rectangle()
            .frame(maxWidth: .infinity)
            .frame(height:1)
            .background(.white)
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
