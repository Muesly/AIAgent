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
    @Namespace var responseID
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: RunPromptViewModel
    @State var loading: Bool = false
    @State var showingError: Bool = false
    @State var height: CGFloat = 50
    @State var responseReady: Bool = false

    init(prompt: Prompt?) {
        viewModel = RunPromptViewModel(prompt: prompt)
    }

    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
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
                            viewModel.text = ""
                        } label: {
                            Text("Clear")
                        }.padding(5)
                        Button {
                            loading = true
                            Task {
                                do {
                                    responseReady = try await viewModel.generate()
                                } catch {
                                    showingError = true
                                }
                                loading = false
                            }
                        } label: {
                            if loading {
                                ProgressView()
                            } else {
                                Text("Run Prompt")
                            }
                        }.buttonStyle(.borderedProminent)
                            .padding(5)

                        if responseReady {
                            VStack {
                                HStack {
                                    Spacer()
                                    Text(viewModel.tokensStats)
                                        .foregroundColor(Color("foregroundSecondary"))
                                        .font(.system(size: 12))
                                        .padding(.bottom, 5)
                                    Spacer()
                                }
                                Text(viewModel.fullResponse)
                                    .textSelection(.enabled)
                                HStack {
                                    Spacer()
                                    Button {
                                        UIPasteboard.general.string = viewModel.fullResponse
                                    } label: {
                                        Image(systemName: "doc.on.doc")
                                            .padding()
                                    }
                                    .id(responseID)
                                    .frame(width: 40)
                                    Spacer()
                                }
                            }
                        }
                        Spacer()
                    }
                    .onChange(of: loading) { loading in
                        if !loading && viewModel.shouldScroll {
                            withAnimation {
                                proxy.scrollTo(responseID)
                            }
                        }
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
