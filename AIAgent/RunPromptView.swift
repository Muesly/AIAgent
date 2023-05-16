//
//  RunPromptView.swift
//  AIAgent
//
//  Created by Tony Short on 14/05/2023.
//

import CoreData
import Foundation
import SwiftUI

struct RunPromptView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: RunPromptViewModel
    @State var loading: Bool = false
    @State var showingError: Bool = false
    @State var reply: String = ""
    @State var height: CGFloat = 50
    init(prompt: Prompt?) {
        viewModel = RunPromptViewModel(prompt: prompt)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    VStack {
                        ZStack(alignment: .leading) {
                            Text(viewModel.text).foregroundColor(.clear).padding(6)
                            TextEditor(text: $viewModel.text)
                        }
                        .cornerRadius(10)
                        .padding(5)
                    }
                    .padding(5)
                    .background(Color("backgroundSecondary"))
                    Button {
                        loading = true
                        Task {
                            do {
                                reply = try await viewModel.generate(promptText: viewModel.text)
                                loading = false
                            } catch {
                                showingError = true
                            }
                        }
                    } label: {
                        if loading {
                            ProgressView()
                        } else {
                            Text("Run Prompt")
                        }
                    }.buttonStyle(.borderedProminent)
                        .padding(5)

                    if !reply.isEmpty {
                        VStack {
                            Text(reply)
                                .textSelection(.enabled)
                            HStack {
                                Spacer()
                                Button {
                                    UIPasteboard.general.string = reply
                                } label: {
                                    Image("doc.on.doc")
                                        .foregroundColor(.white)
                                }
                                .frame(width: 40)
                            }
                            Button {
                                reply = ""
                                viewModel.text = ""
                            } label: {
                                Text("Continue")
                            }.padding(5)
                        }
                    }
                    Spacer()
                }
                .padding()
                .navigationTitle($viewModel.title)
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Button("Close") {
                            dismiss()
                        }
                    }
                }
                .alert("Failed to receive a reply",
                       isPresented: $showingError) {
                    Button("OK", role: .cancel) {}
                }
            }
        }
    }
}

struct Previews_RunPromptView_Previews: PreviewProvider {
    static var previews: some View {
        RunPromptView(prompt: samplePrompt)
    }

    static var samplePrompt: Prompt {
        let prompt = Prompt(context: PersistenceController.preview.container.viewContext)
        prompt.title = "Recipe Generator"
        prompt.imageData = UIImage(named: "recipeImage")!.jpegData(compressionQuality: 1.0)
        prompt.text = "Could you please generate me a Thai recipe?"
        return prompt
    }
}
