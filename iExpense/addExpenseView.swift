//
//  addExpenseView.swift
//  iExpense
//
//  Created by Kevin Muniz on 1/25/24.
//

import SwiftUI

struct addExpenseView: View {
    @Environment (\.dismiss) var dismiss
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    let types = ["Personal", "Business"]
    
    var personalExpense: personalExpenses
    
    var businessExpense: businessExpenses
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    TextField("Name", text: $name)
                    
                    Picker("Type", selection: $type) {
                        ForEach(types, id: \.self) {
                            Text($0)
                        }
                    }
                    TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
                    
                .toolbar {
                    Button("Save") {
                        saveItem()
                        dismiss()
                    }
                }
                .navigationTitle("Add New Expense")
            }
        }
    }
    func saveItem() {
        let encoder = JSONEncoder()
        let item = ExpenseItem(name: name, type: type, amount: amount)
        if item.type == "Business" {
            businessExpense.businessExpenses.append(item)
            print(item)
        } else {
            personalExpense.personalExpenses.append(item)
        }
        
        if let data = try? encoder.encode(item) {
            UserDefaults.standard.setValue(data, forKey: "item")
        } else {
            print("error")
        }
    }
}
 
#Preview {
    addExpenseView(personalExpense: personalExpenses(), businessExpense: businessExpenses())
}
