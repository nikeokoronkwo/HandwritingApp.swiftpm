//
//  ModelViewContainer.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 11/02/2025.
//


import SwiftData
import SwiftUI

/// Demo Container used for Previews needing to use SwiftData Models
struct ModelViewContainer<Content: View, T: PersistentModel>: View {
    let content: Content
    var items: [T]

    init(items: [T] = [], @ViewBuilder _ content: () -> Content) {
        self.content = content()
        self.items = items
    }
    
    init(itemBuilder: () -> [T], @ViewBuilder _ content: () -> Content) {
        self.content = content()
        self.items = itemBuilder()
    }
    
    var container: ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: T.self, configurations: config)

        for item in items {
            container.mainContext.insert(item)
        }

        return container
    }

    var body: some View {
        content
            .modelContainer(container)
    }
}
