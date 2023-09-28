import SwiftUI

struct EditQuoteView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    var editedQuote: Quote
    
    @State private var quote = ""
    @State private var date = Date()
    @State private var author = ""
    @State private var outro = ""
    
    @State private var firstAppear = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            
            VStack(alignment: .leading, spacing: 8){
                ZStack{
                    HStack(){
                        Spacer()
                        Text("edit quote")
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
                Button(action: deleteQuote) {
                    Text("Delete")
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
                
                Spacer()
                
                Button(action: saveQuote) {
                    Text("Save Quote")
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
        .onAppear{
            if firstAppear {
                firstAppear = false
                quote = editedQuote.quote ?? ""
                date = editedQuote.date ?? Date()
                author = editedQuote.author ?? ""
                outro = editedQuote.outro ?? ""
            }
        }
    }
    
    private func deleteQuote() {
        viewContext.delete(editedQuote)
        do {
            try viewContext.save()
        } catch {

            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func saveQuote() {
        editedQuote.quote = quote
        editedQuote.author = author
        editedQuote.date = date
        editedQuote.outro = outro

        CoreData.shared.saveContext()
        presentationMode.wrappedValue.dismiss()
        
  
    }
    
    private func Line () -> some View {
        Rectangle()
            .frame(maxWidth: .infinity)
            .frame(height:1)
            .background(.white)
    }
    
}


//struct EditQuoteView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditQuoteView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
