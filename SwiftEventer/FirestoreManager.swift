//
//  FirestoreManager.swift
//  SwiftEventer
//
//  Created by Евгений Житников on 22.08.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class Event: Codable {
    @DocumentID var id: String?

    var name: String
    var description: String
    var location: String
    var date: Date
    var userOwner: String
    
    init(name: String, description: String, location: String, date: Date, userOwner: String) {
        self.name = name
        self.description = description
        self.location = location
        self.date = date
        self.userOwner = userOwner
    }
}

class FirestoreManager {
    
    let eventsCollection = Firestore.firestore().collection("events")
    
    func addEvent (event: Event, completion: @escaping (Error?) -> ()) {
        _ = try? eventsCollection.addDocument(from: event, completion: { error in
            completion(error)
        })
    }
    
    func updateEvent(event: Event, completion: @escaping (Error?) -> ()) {
        try? eventsCollection.document(event.id!).setData(from: event) { error in
            completion(error)
        }
    }
    
    var listener: ListenerRegistration?
    
    func getEventsList(completion: @escaping ([Event]?) ->()) {
        listener?.remove()
        
        listener = eventsCollection.order(by: "date", descending: false).addSnapshotListener { querySnapshot, error in
            
            let result = querySnapshot?.documents.compactMap({ document in
                return try? document.data(as: Event.self)
            })
            
            completion(result)
        }
    }
    
    func deleteEvent(event: Event, completion: @escaping (Error?) -> ()) {
        eventsCollection.document(event.id!).delete { error in
            completion(error)
        }
    }
    
}
