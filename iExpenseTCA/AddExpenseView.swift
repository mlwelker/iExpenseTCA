
import ComposableArchitecture
import SwiftUI

struct AddExpense { }

extension AddExpense: Reducer {
    struct State: Equatable {
        @BindingState var name = ""
        @BindingState var type = "personal"
        @BindingState var amount = 0.0
    }
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case saveButtonTapped
    }
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce<State, Action> { state, action in
            switch action {
            case .binding: return .none
            case .saveButtonTapped:
                return .run { send in
                    @Dependency(\.dismiss) var dismiss
                    await dismiss()
                }
            }
        }
    }
}

struct AddExpenseView: View {
    let store: StoreOf<AddExpense>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                HStack {
                    Text("Add New Expense").font(.title).bold()
                    
                    Spacer()
                    
                    Button {
                        viewStore.send(.saveButtonTapped)
                    } label: {
                        Text("Save")
                    }
                }
                .padding()
                
                Form {
                    TextField("Name", text: viewStore.$name)
                    
                    Picker("Type", selection: viewStore.$type) {
                        ForEach(ExpenseType.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    
                    TextField("Amount", value: viewStore.$amount, format: .currency(code: Locale.current.currency?.identifier ?? "US"))
                }
            }
        }
    }
}

#Preview {
    AddExpenseView(store: .init(initialState: .init(), reducer: { AddExpense() }))
}
