//
//  EditPromptView.swift
//  AIAgent
//
//  Created by Tony Short on 13/05/2023.
//

import CoreData
import Foundation
import SwiftUI

struct EditPromptView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: EditPromptViewModel

    init(prompt: Prompt?) {
        viewModel = EditPromptViewModel(prompt: prompt)
    }

    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        formatter.allowsFloats = true
        formatter.maximumFractionDigits = 2
        return formatter
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Form {
                    Section(header: Text("Title")) {
                        TextField("Prompt Title", text: $viewModel.title)
                    }
                    Section(header: Text("Image")) {
                        HStack {
                            Spacer()
                            ImagePickerView(image: $viewModel.image)
                            Spacer()
                        }
                    }
                    Section(header: Text("Prompt")) {
                        TextEditor(text: $viewModel.text)
                            .lineLimit(20)
                    }
                    Section(header: Text("Temperature")) {
                        TextField("0.5", value: $viewModel.temperature, formatter: numberFormatter)
                            .keyboardType(.numberPad)
                    }
                    Section(header: Text("Top_P")) {
                        TextField("0.5", value: $viewModel.topP, formatter: numberFormatter)
                            .keyboardType(.numberPad)
                    }
                }
                VStack(alignment: .center) {
                    Button {
                        viewModel.deletePrompt(viewContext: viewContext)
                        dismiss()
                    } label: {
                        Text("Delete Prompt")
                    }.foregroundColor(.red)
                }.frame(maxWidth: .infinity)
            }
            .padding()
            .navigationTitle("Add a Prompt")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .automatic) {
                    Button("Save") {
                        viewModel.savePrompt(viewContext: viewContext)
                        dismiss()
                    }.disabled(viewModel.isSaveDisabled)
                }
            }
        }
    }
}

struct Previews_EditPromptView_Previews: PreviewProvider {
    static var previews: some View {
        EditPromptView(prompt: samplePrompt)
    }

    static var samplePrompt: Prompt {
        let prompt = Prompt(context: PersistenceController.preview.container.viewContext)
        prompt.title = "Recipe Generator"
        prompt.imageData = UIImage(named: "recipeImage")!.jpegData(compressionQuality: 1.0)
        prompt.text = "Could you please generate me a Thai recipe?"
        return prompt
    }
}
