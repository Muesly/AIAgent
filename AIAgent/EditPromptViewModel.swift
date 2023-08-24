//
//  EditPromptViewModel.swift
//  AIAgent
//
//  Created by Tony Short on 14/05/2023.
//

import CoreData
import UIKit

class EditPromptViewModel: ObservableObject {
    @Published var title: String
    @Published var image: UIImage?
    @Published var text: String
    @Published var temperature: Float
    @Published var topP: Float

    let prompt: Prompt?

    init(prompt: Prompt?) {
        self.prompt = prompt
        self.title = prompt?.title ?? ""
        self.image = prompt?.image
        self.text = prompt?.text ?? ""
        self.temperature = prompt?.temperature ?? 0.5
        self.topP = prompt?.top_p ?? 0.5
    }

    var isSaveDisabled: Bool {
        return title.isEmpty || text.isEmpty || (image == nil)
    }

    func savePrompt(viewContext: NSManagedObjectContext) {
        var prompt = self.prompt
        if prompt == nil {
            prompt = Prompt(context: viewContext)
        }
        prompt?.title = title
        prompt?.imageData = image?.jpegData(compressionQuality: 0.9)
        prompt?.text = text
        prompt?.temperature = temperature
        prompt?.top_p = topP

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    func deletePrompt(viewContext: NSManagedObjectContext) {
        guard let prompt else { return }
        viewContext.delete(prompt)
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
