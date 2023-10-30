
import ComposableArchitecture
import SwiftUI

struct Application { }

extension Application: Reducer {
    struct State: Equatable {
        var items: [String:[ExpenseItem]] = [:]
    }
    enum Action: Equatable {
        case loadDataButtonTapped
        case saveButtonTapped([String:[ExpenseItem]])
    }
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadDataButtonTapped:
                state.items = loadItems()
                return .none
            case .saveButtonTapped(let items):
                saveItems(items: items)
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
                        showingAddExpense = true
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
                .sheet(isPresented: $showingAddExpense) {
                    AddView()
                }
                
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
