
import ComposableArchitecture
import SwiftUI

struct Application { }

extension Application: Reducer {
    struct State: Equatable {
        var items: [String:[ExpenseItem]] = [:]
        @BindingState var showingAddExpense: Bool = false
    }
    enum Action: Equatable, BindableAction {
        case loadDataButtonTapped
        case saveButtonTapped([String:[ExpenseItem]])
        case plusButtonTapped
        case binding(BindingAction<State>)
    }
    var body: some Reducer<State, Action> {
        BindingReducer() // creating and running a binding reducer before our reducer runs
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .loadDataButtonTapped:
                state.items = loadItems()
                return .none
            case .saveButtonTapped(let items):
                saveItems(items: items)
                return .none
            case .plusButtonTapped:
                state.showingAddExpense = true
                return .none
            }
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
    
    // TODO: move this binding into TCA
    @State private var showingAddExpense = false
    
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
                .sheet(isPresented: viewStore.$showingAddExpense) {
                    AddView()
                }
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
