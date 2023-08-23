//
//  EventsController.swift
//  SwiftEventer
//
//  Created by Евгений Житников on 22.08.2023.
//

import UIKit
import FirebaseAuth

class EventsController: UITableViewController {
    let firestoreManager = FirestoreManager()
    var events: [Event] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        createdLogInButton()
        reloadData()
    }
    
    func reloadData() {
        firestoreManager.getEventsList { [weak self] events in
            self?.events = events ?? []
            self?.tableView.reloadData()
        }
    }


    func createdLogInButton() {
        if Auth.auth().currentUser == nil {
            let logInButton = UIBarButtonItem(title: "Log in", style: .plain, target: self, action: #selector(pushLogInButton))
            navigationItem.leftBarButtonItem = logInButton
            pushAddEventButton.isEnabled = false
        } else {
            let logOutButton = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(pushLogOutButton))
            navigationItem.leftBarButtonItem = logOutButton
            pushAddEventButton.isEnabled = true

        }
    }
    
    @objc func pushLogInButton() {
        let nc = storyboard!.instantiateViewController(withIdentifier: "loginNCSID")
        nc.modalPresentationStyle = .fullScreen
        present(nc, animated: true)
    }
    
    @objc func pushLogOutButton() {
        try? Auth.auth().signOut()
        createdLogInButton()
    }
    
    @IBOutlet weak var pushAddEventButton: UIBarButtonItem!
    
    @IBAction func pushAddButtonAction(_ sender: Any) {
        EventController.pushEventController(in: self, with: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var configuration = UIListContentConfiguration.cell()
        configuration.text = events[indexPath.row].name
        configuration.secondaryText = events[indexPath.row].location
        cell.contentConfiguration = configuration

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        EventController.pushEventController(in: self, with: events[indexPath.row])

    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if events[indexPath.row].userOwner == Auth.auth().currentUser?.email {
            return true
        }
        return false
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            firestoreManager.deleteEvent(event: events[indexPath.row]) { [weak self] error in
                if let error {
                    print(error)
                    return
                }
                
                self?.reloadData()
            }
        } else if editingStyle == .insert {

        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
