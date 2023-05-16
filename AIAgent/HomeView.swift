//
//  ContentView.swift
//  AIAgent
//
//  Created by Tony Short on 13/05/2023.
//

import CoreData
import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    internal let inspection = Inspection<Self>()

    @State var promptToEdit: Prompt?
    @State var promptToRun: Prompt?
    @State var isShowingAddPromptView: Bool = false

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Prompt.title, ascending: true)],
        animation: .default)
    private var prompts: FetchedResults<Prompt>

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(prompts, id: \.self) { prompt in
                        PromptCellView(title: prompt.title!,
                                       image: prompt.image, onEditTap: {
                            promptToEdit = prompt
                        }, onRunTap: {
                            promptToRun = prompt
                        })
                    }
                    AddPromptCellView(title: "+ Add a Prompt") {
                        isShowingAddPromptView = true
                    }
                }
                .padding()
            }
            .navigationTitle("Prompts")
            .sheet(item: $promptToEdit) { prompt in
                EditPromptView(prompt: prompt)
            }
            .sheet(item: $promptToRun) { prompt in
                RunPromptView(prompt: prompt)
            }
            .sheet(isPresented: $isShowingAddPromptView) {
                EditPromptView(prompt: nil)
            }
            .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
