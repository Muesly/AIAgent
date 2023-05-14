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
    let prompt: Prompt?

    init(prompt: Prompt?) {
        self.prompt = prompt
        self.title = prompt?.title ?? ""
        self.image = prompt?.image
        self.text = prompt?.text ?? ""
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
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
