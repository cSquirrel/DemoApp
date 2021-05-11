//
//  DataFilterView.swift
//  SpaceX
//
//  Created by Marcin Maciukiewicz on 07/05/2021.
//

import SwiftUI
import Combine

struct FilterView: View {
    
    struct CheckBoxView: View {
        
        @Binding var value: Bool?
        @State var imageName: String = "square"
        
        private func toggle() {
            if let state = value, state == true {
                value = false
            } else if let state = value, state == false {
                value = nil
            } else {
                value = true
            }
        }
        
        private func imageNameFor(state: Bool?) -> String {
            if let state = state {
                return state ? "checkmark.square.fill" : "multiply.square"
            } else {
                return "square"
            }
        }
        
        var body: some View {
            Button(action: toggle){
                Image(systemName: imageNameFor(state: value))
            }
        }
    }
    
    @Binding var year: String
    @Binding var status: Bool?
    @Binding var sortAscending: Bool
    
    var sortLabel: String {
        return sortAscending ? "DESC" : "ASC" 
    }
    
    var body: some View {
        VStack {
            Text("Filter Settings")
            
            HStack(alignment: .top) {
                VStack(alignment: .trailing, spacing:10) {
                    Text("Launch Year")
                    Text("Successful launch?")
                    Text("Sorting order")
                }.frame(maxWidth: .infinity)
                VStack(alignment: .leading, spacing:10) {
                    TextField("Enter Year", text: $year)
                        .keyboardType(.decimalPad)
                    CheckBoxView(value: $status)
                    Button(sortLabel) {
                        sortAscending.toggle()
                    }
                }
            }
        }.padding()
    }
}

struct FilterView_Previews: PreviewProvider {
    
    @State static var year: String = "2008"
    @State static var status: Bool? = nil
    @State static var sortAscending: Bool = false
    
    static var previews: some View {
        FilterView(year: $year, status: $status, sortAscending: $sortAscending)
    }
}
