//
//  DeveloperPreview.swift
//  Agios
//
//  Created by Victor on 22/04/2024.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}


class DeveloperPreview {
    
    static let instance = DeveloperPreview()
    private init() { }
    
    let occasionsViewModel = OccasionsViewModel()
    
    let icon = IconModel(
        id: "7hcbmyqwty25hjc", created: "2024-04-20T21:19:22.339Z",
        updated: "2024-04-20T21:19:22.339Z",
        caption: "The Honourable Archangeal Michael",
        image: "https://agios-calendar.pockethost.io/api/files/nwill40feaquna2/yl7g57ypngzbfjs/the_righteous_job_rQtvvhe5JK.jpeg",
        croppedImage: "",
        iconagrapher: Iconagrapher(
            created: "2024-04-20T21:19:22.339Z",
            id: "7hcbmyqwty25hjc",
            name: "Girgis Samir",
            updated: "2024-04-20 21:19:12.978Z")
    )
    
    let iconagrapher = Iconagrapher(
        created: "2024-04-20T21:19:22.339Z",
        id: "7hcbmyqwty25hjc",
        name: "Girgis Samir",
        updated: "2024-04-20 21:19:12.978Z")
    
    let passages = Passage(
        bookID: 19,
        bookTranslation: "Psalms",
        chapter: 7, ref: "17:3,5",
        verses: [
            Verse(id: 156753, bibleID: 2, bookID: 19, chapter: 17, number: 3, text: "You have tested my heart; You have visited me in the night; You have tried me and have found nothing; I have purposed that my mouth shall not transgress."),
            
            Verse(id: 156753, bibleID: 2, bookID: 19, chapter: 17, number: 3, text: "Uphold my steps in Your paths, That my footsteps may not slip.")
        ]
        
    )
    
    let verses = Verse(
        id: 156753,
        bibleID: 2, 
        bookID: 19,
        chapter: 17,
        number: 3,
        text: "You have tested my heart; You have visited me in the night; You have tried me and have found nothing; I have purposed that my mouth shall not transgress.")
    
    let reading = DataReading(id: 1, title: "Reading", subSections: [])
    
    let pastelColor = PastelColors(pastelColors: [
        Color(red: 253/255, green: 225/255, blue: 225/255),  // Pastel Red
        Color(red: 253/255, green: 246/255, blue: 215/255),  // Pastel Yellow
        Color(red: 215/255, green: 253/255, blue: 221/255),  // Pastel Green
        Color(red: 215/255, green: 230/255, blue: 253/255),  // Pastel Blue
        Color(red: 253/255, green: 225/255, blue: 253/255),  // Pastel Pink
        Color(red: 1.0, green: 0.89, blue: 0.71), // Pastel Yellow (FFE4B5)
        Color(red: 0.97, green: 0.67, blue: 0.67)  // Pastel Pink (F8ACAC)
    ])
}
