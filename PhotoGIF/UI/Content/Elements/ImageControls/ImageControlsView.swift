//
//  ImageControlsView.swift
//  PhotoGIF
//
//  Created by Yu-Sung Loyi Hsu on 2025/2/5.
//  Copyright © 2025 Loyi Hsu. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct ImageControlsView: View {
    @Bindable var store: StoreOf<ImageControlsFeature>

    var body: some View {
        Group {
            VStack {
                HStack {
                    Text("🗂 \(self.store.displayOutputPath)")
                    Button(LocalizedStringKey("change")) {
                        self.store.send(.selectPath)
                    }
                }

                HStack {
                    Text(LocalizedStringKey("filename"))
                    TextField(
                        LocalizedStringKey("filename"),
                        text: self.$store.outputFilename
                    )
                    .frame(width: 135, height: 12, alignment: .center)
                }
            }

            HStack {
                Button(LocalizedStringKey("generate")) {
                    self.store.send(.generate)
                }
                .disabled(!self.store.canGenerate)
                Text(self.makeSymbolForGenerationState(self.store.generationState))
            }
            .padding()
        }
    }

    private func makeSymbolForGenerationState(_ state: GenerationState?) -> String {
        switch state {
        case .success:
            return "✅"
        case .failure:
            return "❌"
        case .loading:
            return "🏃‍♀️"
        case .none:
            return ""
        }
    }
}

#Preview {
    ImageControlsView(
        store: StoreOf<ImageControlsFeature>(
            initialState: ImageControlsFeature.State(),
            reducer: {
                ImageControlsFeature()
            }
        )
    )
}
