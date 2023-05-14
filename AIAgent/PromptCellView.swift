//
//  PromptCellView.swift
//  AIAgent
//
//  Created by Tony Short on 14/05/2023.
//

import SwiftUI

struct PromptCellView: View {
    let title: String
    let image: UIImage?
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .overlay(Text(title)
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding(6)
                                .foregroundColor(.white)
                                .background(Color.black.opacity(0.6)),
                             alignment: .bottom)
            } else {
                Text("\(title)")
                    .bold()
                    .foregroundColor(.white)
            }
        }
        .frame(height: 140)
        .frame(maxWidth: .infinity)
        .background(image == nil ? .purple : .white)
        .cornerRadius(10)
    }
}
