//
//  RealmSchema.swift
//  IOS Assisgnment
//
//  Created by Lokesh on 30/08/21.
//

import Foundation
import RealmSwift
import ObjectMapper
 class CountryDetail: Object,Mappable{
    @objc dynamic  var UId: String?
    @objc dynamic  var Country: String?
    @objc dynamic  var Slug: String?
    @objc dynamic  var ISO2: String?
   
    
    override  static func primaryKey() -> String? {
        return "UId"
    }
    required convenience  init?(map: Map) {
        self.init()
    }
      func mapping(map: Map) {
        UId <- map["Country"]
        Country <- map["Country"]
        Slug <- map["Slug"]
        ISO2 <- map["ISO2"]
      
      }
}
