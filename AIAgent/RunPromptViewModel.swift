//
//  RunPromptViewModel.swift
//  AIAgent
//
//  Created by Tony Short on 14/05/2023.
//

import UIKit

enum PromptError: Error {
    case failedToDecodeRecipeFromResponse
    case failedToFindContentInResponse
}

class RunPromptViewModel: ObservableObject {
    @Published var title: String
    @Published var text: String
    let prompt: Prompt?

    init(prompt: Prompt?) {
        self.prompt = prompt
        self.title = prompt?.title ?? ""
        self.text = prompt?.text ?? ""
    }

    func generate(promptText: String) async throws -> String {
        let apiKey = Bundle.main.infoDictionary!["GPT API Key"]!
        let urlString = "https://api.openai.com/v1/chat/completions"
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]

        let parameters: [String : Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [[ "role": "user", "content": promptText]]
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])

        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        let response: GPTResponse
        do {
            response = try decoder.decode(GPTResponse.self, from: data)
        } catch {
            throw PromptError.failedToDecodeRecipeFromResponse
        }
        guard let content = response.content else {
            throw PromptError.failedToFindContentInResponse
        }

        return content
    }
}

struct GPTResponse: Decodable {
    struct GPTMessage: Decodable {
        let content: String
    }

    struct GPTChoice: Decodable {
        let message: GPTMessage
    }
    let choices: [GPTChoice]

    var content: String? {
        choices.first?.message.content
    }
}
