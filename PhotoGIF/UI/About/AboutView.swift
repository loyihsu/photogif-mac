//
//  AboutView.swift
//  PhotoGIF
//
//  Created by Loyi Hsu on 2020/5/17.
//  Copyright © 2020 Loyi Hsu. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Image(nsImage: NSImage(named: "AppIcon")!)
                .padding(.bottom)
            Text("\(self.getBundleData(for: .appName))")
                .font(.largeTitle)
                .padding(8)
            Text("Ver. \(self.getBundleData(for: .versionString)) (\(self.getBundleData(for: .buildString)))")
                .padding(.bottom, 20)
            Text("\(self.getBundleData(for: .copyrightString))")
                .font(.caption)
        }
        .frame(width: 450, height: 290, alignment: .center)
    }

    private func getBundleData(for key: BundleData) -> String {
        return key.string() ?? ""
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
