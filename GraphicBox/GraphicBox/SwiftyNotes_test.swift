//
//  SwiftyNotes.swift
//  GraphicBox
//
//  Created by Alessandro Marconi on 11/07/2018.
//  Copyright © 2018 Alessandro Marconi. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SwiftyPerson {
    let name: String
    let location: String
    let company: String
    
    init?(data: Data){
    do {
        let json = try JSON(data: data)
        
        guard let name = json[0]["name"].string,
            let lat = json[0]["address"]["geo"]["lat"].string,
            let long = json[0]["address"]["geo"]["lng"].string,
            let company = json[0]["company"]["name"].string
            else { return nil }
        
        self.name = name
        self.location = "Lat: \(lat) Long: \(long)"
        self.company = company
    } catch
        {
            let nserror = error as NSError
            fatalError("Unresolved data parsing error in SwiftyNotes  \(nserror), \(nserror.userInfo)")
        }
    }
}
