//
//  ListScreen.swift
//  ControllerExampleApp
//
//  Created by Manu on 16/03/2023.
//

import SwiftUI
import ViewStateController

struct ListScreen: View {
    @State var controller: ViewStateController<[Pokemon]> = .init()

    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                EmptyView()
                    .withViewStateModifier(
                        controller: controller,
                        loadedView: { pokemons in
                            listView(pokemons)
                        },
                        loadingAfterInfoType: .overCurrentContent(contentOpacity: 0.2),
                        errorView: { _ in
                            .init(retryAction: {
                                initializeState()
                            })
                        })
                Spacer()
                Button("Reset State") {
                    withAnimation {
                        initializeState()
                    }
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .navigationTitle("List")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                initializeState()
            }
        }
        .debugState(controller: $controller, mockInfo: [.init(id: "1", name: "Mock Pokemon")])
    }

    func initializeState() {
        Task {
            controller.setState(.loading)
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            withAnimation {
                controller.setState(.loaded(
                    [
                        .init(id: "1", name: "Bulbasaur"),
                        .init(id: "4", name: "Squirtle"),
                        .init(id: "7", name: "Charmander"),
                        .init(id: "10", name: "Caterpie"),
                        .init(id: "11", name: "Metapod"),
                        .init(id: "12", name: "Butterfree"),
                        .init(id: "151", name: "Mew")
                    ]
                ))
            }
        }
    }

    func listView(_ pokemons: [Pokemon]) -> some View {
        VStack {
            ForEach(pokemons) { pokemon in
                HStack {
                    Text(pokemon.name)
                    Spacer()
                    trailingView(for: pokemon.id)
                }
                Divider()
            }
        }
    }

    @ViewBuilder
    func trailingView(for id: String) -> some View {
        if let modifyingIds = controller.modifyingIds, modifyingIds.contains(id) {
            // If the id is in the `modifyingIds` array, it means someone is modifying it.
            // So we display a loading indicator.
            ProgressView()
        } else {
            // Otherwise, we display a remove button.
            Button("Remove", role: .destructive) {
                Task {
                    // Tapping the button triggers an async call to remove the pokemon.
                    await removePokemon(id: id)
                }
            }
        }
    }

    func removePokemon(id: String) async {
        withAnimation {
            // We add the `id` to the array.
            controller.modifyingIds = (controller.modifyingIds ?? []) + [id]
        }
        // We simulate an async call to the backend. (1 second sleep)
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        if let latestInfo = controller.latestInfo {
            let updatedInfo = latestInfo.filter { pokemon in
                pokemon.id != id
            }
            withAnimation {
                // Then we update the state
                controller.setState(.loaded(updatedInfo))
                // And remove the id from the modifying array
                controller.modifyingIds?.removeAll(where: { $0 == id })
            }
        }
    }

    struct Pokemon: Identifiable {
        let id: String
        let name: String
    }
}

struct ListScreen_Previews: PreviewProvider {
    static var previews: some View {
        ListScreen()
    }
}
