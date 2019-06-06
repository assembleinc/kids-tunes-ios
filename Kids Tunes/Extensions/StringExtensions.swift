//
//  StringExtensions.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/28/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

extension String {
    func replaceSpacesWithPlusSigns() -> String {
        return replacingOccurrences(of: " ", with: "+")
    }
}
