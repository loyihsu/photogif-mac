//
//  AboutView.swift
//  PhotoGIF
//
//  Created by Loyi Hsu on 2020/5/17.
//  Copyright © 2020 Loyi Hsu. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    func getCFBundleString(for key: String) -> String {
        let information = Bundle.main.infoDictionary?[key] as? String
        return information ?? "Error"
    }

    var body: some View {
        VStack {
            Image(nsImage: NSImage(named: "AppIcon")!)
                .padding(.bottom)
            Text("\(self.getCFBundleString(for: "CFBundleName"))")
                .font(.largeTitle)
                .padding(8)
            Text("Ver. \(self.getCFBundleString(for: "CFBundleShortVersionString")) (\(self.getCFBundleString(for: "CFBundleVersion")))")
                .padding(.bottom, 20)
            Text("\(self.getCFBundleString(for: "NSHumanReadableCopyright"))")
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
