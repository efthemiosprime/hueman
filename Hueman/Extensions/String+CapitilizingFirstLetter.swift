//
//  String+CapitilizingFirstLetter.swift
//  Hueman
//
//  Created by Efthemios Prime on 1/1/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

extension String {

func capitalizingFirstLetter() -> String {
    let first = String(characters.prefix(1)).uppercaseString
    let other = String(characters.dropFirst())
    return first + other
}

mutating func capitalizeFirstLetter() {
    self = self.capitalizingFirstLetter()
}
}
