//
//  ContentView.swift
//  PhotoGIF
//
//  Created by Loyi Hsu on 2020/5/15.
//  Copyright © 2020 Loyi Hsu. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct ContentView: View {
    var store: StoreOf<ContentFeature>

    var body: some View {
        VStack {
            ImageListView(
                store: self.store.scope(state: \.listState, action: \.list)
            )
            ImageControlsView(
                store: self.store.scope(state: \.controlState, action: \.control)
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return ContentView(
            store: StoreOf<ContentFeature>(
                initialState: ContentFeature.State(),
                reducer: {
                    ContentFeature()
                }
            )
        )
    }
}
