//
//  ImagePickerView.swift
//  Recipes
//
//  Created by Tony Short on 08/04/2023.
//

import SwiftUI

struct ImagePickerView: View {
    @Binding private var image: UIImage?
    @State private var actionSheetShown = false
    @State private var chooseFromLibraryOption = false

    init(image: Binding<UIImage?>) {
        _image = image
    }

    var body: some View {
        VStack {
            Button {
                if image == nil {
                    actionSheetShown = true
                }
            } label: {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipped()
                        .cornerRadius(10)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                        .foregroundColor(Color("backgroundSecondary"))
                }
            }
        }
        .confirmationDialog("Select an option", isPresented: $actionSheetShown, titleVisibility: .hidden) {
            Button("Choose from library") {
                chooseFromLibraryOption = true
            }
        }
        .sheet(isPresented: $chooseFromLibraryOption) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        }
    }
}
