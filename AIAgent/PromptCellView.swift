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
    let onEditTap: () -> Void
    let onRunTap: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button {
                onRunTap()
            } label: {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 176, height: 140)
                        .clipped()
                        .overlay(
                            ZStack(alignment: .topTrailing) {
                                Text(title)
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding(10)
                                    .foregroundColor(.white)
                                    .background(Color.black.opacity(0.6))
                                Button {
                                    onEditTap()
                                } label: {
                                    Image(systemName: "ellipsis.circle")
                                }
                                .padding(10)
                                .foregroundColor(.white)
                            }, alignment: .bottom)
                }
            }
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .cornerRadius(10)
        }
    }
}

struct AddPromptCellView: View {
    let title: String
    let onTap: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button {
                onTap()
            } label: {
                Text("\(title)")
                    .bold()
                    .foregroundColor(.white)
            }
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .background(.purple)
            .cornerRadius(10)
        }
    }
}
