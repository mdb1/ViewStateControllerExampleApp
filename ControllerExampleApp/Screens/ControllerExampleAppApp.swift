//
//  ControllerExampleAppApp.swift
//  ControllerExampleApp
//
//  Created by Manu on 01/03/2023.
//

import SwiftUI

@main
struct ControllerExampleAppApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                DemoScreen()
                    .tabItem {
                        VStack {
                            Image(systemName: "checklist.rtl")
                            Text("Demo")
                        }
                    }
                ListScreen()
                    .tabItem {
                        VStack {
                            Image(systemName: "opticaldisc")
                            Text("List")
                        }
                    }
            }
        }
    }
}
