//
//  AboutView.swift
//  PhotoGIF
//
//  Created by Loyi Hsu on 2020/5/17.
//  Copyright © 2020 Loyi Hsu. All rights reserved.
//

import Dependencies
import SwiftUI

struct AboutView: View {
    @Dependency(\.bundle) var bundle

    var body: some View {
        VStack {
            Image(nsImage: NSImage(named: "AppIcon")!)
                .padding(.bottom)
            Text("\(self.bundle(.appName))")
                .font(.largeTitle)
                .padding(8)
            Text("Ver. \(self.bundle(.versionString)) (\(self.bundle(.buildString)))")
                .padding(.bottom, 20)
            Text("\(self.bundle(.copyrightString))")
                .font(.caption)
        }
        .frame(width: 450, height: 290, alignment: .center)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
