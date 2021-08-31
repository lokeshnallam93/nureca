//
//  CountryModel.swift
//  IOS Assisgnment
//
//  Created by Lokesh on 29/08/21.
//

import Foundation

class CountryModel : Decodable {
    
    var Country: String
    var Slug: String
    var ISO2 : String

    init(country: String, slug: String, iSO2: String) {
        self.Country = country
        self.Slug = slug
        self.ISO2 = iSO2
       
    }
}
