
import ComposableArchitecture
import SwiftUI

struct AddView: View {
    // TODO: provide access to the store or create one for this view?
    
    // Q: can/should dismiss also be done in TCA?
    @Environment(\.dismiss) var dismiss
    
    // TODO: move these bindings into TCA
    @State private var name = ""
    @State private var type = "personal"
    @State private var amount = 0.0
    
    var body: some View {
        VStack {
            HStack {
                Text("Add New Expense").font(.title).bold()
                
                Spacer()
                
                Button {
                    //TODO: add item to expenses, dismiss modal
                    dismiss()
                } label: {
                    Text("Save")
                }
            }
            .padding()
            
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(ExpenseType.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "US"))
            }
        }
    }
}

#Preview {
    AddView()
}
