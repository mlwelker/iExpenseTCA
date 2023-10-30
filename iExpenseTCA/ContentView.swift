
import ComposableArchitecture
import SwiftUI

struct Application { }

extension Application: Reducer {
    struct State: Equatable {
        var items: [String:[ExpenseItem]] = [:]
//        @PresentationState var destination: Destination.State?
        @PresentationState var addExpense: AddExpense.State?
        // @BindingState mostly used in TCA within Forms
    }
    enum Action: Equatable {
        case loadDataButtonTapped
        case saveButtonTapped([String:[ExpenseItem]])
        case plusButtonTapped
//        case destination(PresentationAction<Destination.Action>)
        case addExpense(PresentationAction<AddExpense.Action>)
    }
//    struct Destination: Reducer {
//        enum State: Equatable {
//            case addExpense
//        }
//        enum Action: Equatable {
//            case addExpense
//        }
//        var body: some ReducerOf<Self> {
//            EmptyReducer()
//        }
//    }
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .addExpense:
                return .none
//            case .destination:
//                return .none
            case .loadDataButtonTapped:
                state.items = loadItems()
                return .none
            case .saveButtonTapped(let items):
                saveItems(items: items)
                return .none
            case .plusButtonTapped:
                state.addExpense = .init()
//                state.destination = .addExpense
                return .none
            }
        }
//        .ifLet(\.$destination, action: /Application.Action.destination) {
//            Destination()
//        } // this runs only if the destination state is populated (ie not nil, hence ifLet won't run if nil)
        .ifLet(\.$addExpense, action: /Application.Action.addExpense) {
            AddExpense()
        }
    }
    
    func loadItems() -> [String:[ExpenseItem]] {
        if let data = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([String:[ExpenseItem]].self, from: data) {
                return decodedItems
            }
        }
        return [:]
    }
    
    func saveItems(items: [String:[ExpenseItem]]) {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: "Items")
        }
    }
}

struct ContentView: View {
    let store: StoreOf<Application>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                HStack {
                    Text("iExpense").font(.largeTitle).bold()
                    Spacer()
                    Button {
                        viewStore.send(.plusButtonTapped)
                    } label: {
                        Image(systemName: "plus").font(.title)
                    }
                }
                .padding()
                List {
                    Section {
                        // TODO: ExpensesList
                    } header: {
                        Text("personal")
                    }
                    Section {
                        // TODO: ExpensesList
                    } header: {
                        Text("business")
                    }
                }
                .sheet(store: store.scope(state: \.$addExpense, action: { .addExpense($0) })) {
                    AddExpenseView(store: $0)
                }
//                .sheet(isPresented: viewStore.$showingAddExpense) {
//                    AddView()
//                }
                // @PresentationState
                
                Button {
                    viewStore.send(.loadDataButtonTapped)
                } label: {
                    Text("Load Data")
                }
            }
        }
    }
}

#Preview {
    ContentView(store: Store.init(
        initialState: Application.State(),
        reducer: { Application() })
    )
}
