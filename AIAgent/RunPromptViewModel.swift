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

struct Message: Encodable {
    let role: String
    let content: String
}

class RunPromptViewModel: ObservableObject {
    @Published var title: String
    @Published var text: String
    let prompt: Prompt?
    var messages: [Message]
    let jsonEncoder = JSONEncoder()
    var usageState: GPTResponse.Usage?

    init(prompt: Prompt?) {
        self.prompt = prompt
        self.title = prompt?.title ?? ""
        self.text = prompt?.text ?? ""

        self.messages = [Message(role: "system", content: "You are a helpful assistant.")]
    }

    var tokensStats: String {
        guard let usageState else { return "N/A" }
        return "Prompt: \(usageState.promptTokens), Completion: \(usageState.completionTokens), Total Tokens: \(usageState.totalTokens)"
    }

    var fullResponse: String {
        messages.filter { $0.role != "system" }.map { $0.content }.joined(separator: "\n\n")
    }

    var shouldScroll: Bool {
        return messages.count > 3
    }

    func generate() async throws -> Bool {

        messages.append(Message(role: "user", content: text))

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
            "messages": messages.map { ["role": $0.role, "content": $0.content] },
            "temperature": prompt?.temperature ?? 0.5,
            "top_p": prompt?.top_p ?? 0.5
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

        usageState = response.usage
        messages.append(Message(role: "assistant", content: content))

        return true
    }
}

struct GPTResponse: Decodable {
    struct GPTMessage: Decodable {
        let content: String
    }

    struct Usage: Decodable {
        let promptTokens: Int
        let completionTokens: Int
        let totalTokens: Int

        enum CodingKeys: String, CodingKey {
            case promptTokens = "prompt_tokens"
            case completionTokens = "completion_tokens"
            case totalTokens = "total_tokens"
        }
    }

    let usage: Usage

    struct GPTChoice: Decodable {
        let message: GPTMessage
    }
    let choices: [GPTChoice]

    var content: String? {
        choices.first?.message.content
    }
}
