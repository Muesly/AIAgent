//
//  Prompt.swift
//  AIAgent
//
//  Created by Tony Short on 14/05/2023.
//

import UIKit

extension Prompt {
    var image: UIImage? {
        UIImage(data: imageData ?? Data())
    }
}
