//
//  Pizza.swift
//  Domain
//
//  Created by Balázs Kilvády on 2/17/20.
//  Copyright © 2020 kil-dev. All rights reserved.
//

import Foundation
import class UIKit.UIImage

public struct Pizza: Codable {
    public let name: String
    public let ingredients: [Ingredient.ID]
    public let imageUrl: String?
}