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
                            .font(.appTitle)
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
                        .font(.appBody)
                        .padding(4)
                        .frame(height: 100, alignment: .leading)
                        .background(Color.fadedLuminary)
                        .cornerRadius(4)
                }
                .font(.appBody)
                
                VStack(alignment: .leading, spacing:10){
                    Text("Author:")
                    TextField("Author", text: $author)
                        .font(.appBody)
                        .padding(8)
                        .background(Color.fadedLuminary)
                        .cornerRadius(4)
                }
                .font(Font.custom("Baskervville-Regular", size: 16))
                
                VStack(alignment: .leading, spacing:10){
                    Text("Origin:")
                    TextField("Book of Tales", text: $outro)
                        .font(.appBody)
                        .padding(8)
                        .background(Color.fadedLuminary)
                        .cornerRadius(4)
                }
                .font(.appBody)
            }
            .padding(.vertical, 10)
            
            
            HStack{
                
                Spacer()
                
                Button(action: addQuote) {
                    Text("Add Quote")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .font(.appBody)
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
            
            
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "lightbulb")
                    .font(Font.custom("SF Pro", size: 16))
                    .foregroundColor(.textLuminary)
                
                VStack(spacing: 4){
                    Text("Quick tip!")
                        .font(Font.custom("LibreBaskerville-Bold", size: 14))
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    Text("You can add a shortcut for easier addings and then just call \"Hey Siri, save a quote!\"")
                      .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                .font(
                  Font.custom("Baskervville-Regular", size: 16)
                )
                .foregroundColor(.textLuminary)
                
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .cornerRadius(4)
            .overlay(
              RoundedRectangle(cornerRadius: 4)
                .inset(by: 0.5)
                .stroke(Color.textLuminary, lineWidth: 1)
            )
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
        CoreData.shared.saveQuote(quote: quote, author: author, date: date, outro: outro)
        presentationMode.wrappedValue.dismiss()
        
  
    }
    
}


struct AddQuoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddQuoteView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
