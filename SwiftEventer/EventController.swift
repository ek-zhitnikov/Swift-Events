//
//  EventController.swift
//  SwiftEventer
//
//  Created by Евгений Житников on 22.08.2023.
//

import UIKit
import FirebaseAuth

class EventController: UITableViewController {

    var event: Event?
    
    private let firestoreManager = FirestoreManager()
    
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textLocation: UITextField!
    @IBOutlet weak var textDescription: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let event {
            textName.text = event.name
            textLocation.text = event.location
            textDescription.text = event.description
            datePicker.date = event.date
            
            if event.userOwner != Auth.auth().currentUser?.email {
                saveButton.isHidden = true
            }
        }
        if Auth.auth().currentUser?.email == nil {
            saveButton.isHidden = true
        }
    }
    
    @IBAction func pushSaveAction(_ sender: Any) {
        if let event {
            event.name = textName.text!
            event.location = textLocation.text!
            event.description = textDescription.text!
            event.date = datePicker.date
            firestoreManager.updateEvent(event: event) { [weak self] error in
                if let error {
                    print(error)
                    return
                }
                self?.navigationController?.popViewController(animated: true)

            }
            
        } else {
            // не забыть сделать проверки
            let newEvent = Event(name: textName.text!, description: textDescription.text!, location: textLocation.text!, date: datePicker.date, userOwner: Auth.auth().currentUser!.email!)
            firestoreManager.addEvent(event: newEvent) { [weak self] error in
                if let error {
                    print(error)
                    return
                }
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension EventController {
    static func pushEventController (in viewController: UIViewController, with event: Event?) {
        let ec = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventController") as! EventController
        ec.event = event
        viewController.navigationController?.pushViewController(ec, animated: true)
    }
}
