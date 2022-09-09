//
//  Alerts.swift
//  todo list project
//
//  Created by Abdullah Elbokl on 09/09/2022.
//

import Foundation
import UIKit
import PopupView
import SwiftUI

let VC = storyboard?.instantiateViewController(withIdentifier: "editVC")

struct ContentView: View {
    @State var showingPopup = false
    var body: some View {
        YourView()
            .popup(isPresented: $showingPopup, autohideIn: 2) {
                Text("The popup")
                    .frame(width: 200, height: 60)
                    .background(Color(red: 0.85, green: 0.8, blue: 0.95))
                    .cornerRadius(30.0)
            }
    }
}
