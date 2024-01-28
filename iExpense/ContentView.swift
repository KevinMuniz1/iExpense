//
//  ContentView.swift
//  iExpense
//
//  Created by Kevin Muniz on 1/24/24.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class businessExpenses {
    
    var businessExpenses = [ExpenseItem]() {
        didSet {
            if let data = try? JSONEncoder().encode(businessExpenses) {
                UserDefaults.standard.set(data, forKey: "businessExpenses")
            }
        }
    }
    init() {
        if let savedData = UserDefaults.standard.data(forKey: "businessExpenses") {
            if let decoded = try? JSONDecoder().decode([ExpenseItem].self, from: savedData) {
                businessExpenses = decoded
                return
            }
        }
        businessExpenses = []
    }
}

@Observable
class personalExpenses {
    
    
    var personalExpenses = [ExpenseItem]() {
        didSet {
            if let data = try? JSONEncoder().encode(personalExpenses) {
                UserDefaults.standard.set(data, forKey: "personalExpenses")
            }
          }
        }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "personalExpenses") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                personalExpenses = decodedItems
                return
            }
        }
        personalExpenses = []
    }
}

struct ContentView: View {
    @State private var personalItems = personalExpenses()
    @State private var businessItems = businessExpenses()
    @State private var expenseViewIsShowing = false
    var body: some View {
        NavigationStack {
            List {
                Section(!personalItems.personalExpenses.isEmpty ? "Personal" : "") {
                    ForEach(personalItems.personalExpenses) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(item.name)")
                                    .font(.headline)
                                Text("\(item.type)")
                            }
                            Spacer()
                            
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .foregroundStyle(item.amount > 10 ? .red : .green)
                                .font(item.amount > 100 ? .title : .headline)
                        }
                    }.onDelete(perform: deletePersonalItem)
                }
                Section(!businessItems.businessExpenses.isEmpty ? "Business" : "") {
                    ForEach(businessItems.businessExpenses) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(item.name)")
                                    .font(.headline)
                                Text("\(item.type)")
                            }
                            Spacer()
                            
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .foregroundStyle(item.amount > 10 ? .red : .green)
                                .font(item.amount > 100 ? .title : .headline)
                        }
                    }.onDelete(perform: deleteBusinessItem)
                }
                
            }.toolbar {
                    Button("Add Expense", systemImage: "plus") {
                        expenseViewIsShowing.toggle()
                    }
            }
            .sheet(isPresented: $expenseViewIsShowing) {
                addExpenseView(personalExpense: personalItems, businessExpense: businessItems)
            }            .navigationTitle("iExpense")
        }
    }
    
    func deletePersonalItem(offset: IndexSet) {
        personalItems.personalExpenses.remove(atOffsets: offset)
    }
    
    func deleteBusinessItem(offset: IndexSet) {
        businessItems.businessExpenses.remove(atOffsets: offset)
    }
    
}

#Preview {
    ContentView()
}
