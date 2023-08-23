//
//  SingUpController.swift
//  SwiftEventer
//
//  Created by Евгений Житников on 22.08.2023.
//

import UIKit
import FirebaseAuth

class SingUpController: UITableViewController {

    @IBOutlet weak var textLogin: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var textConfirmPassword: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.row == 3 {
            guard let login = textLogin.text, !login.isEmpty else {
                print("Login is empty")
                return
            }
            
            guard let password = textPassword.text, !password.isEmpty else {
                print("Password is empty")
                return
            }
            
            guard let confirmPassword = textConfirmPassword.text, !confirmPassword.isEmpty else {
                print("ConfirmPassword is empty")
                return
            }
            
            if password != confirmPassword {
                print("passwords are different")
                return
            }
            
            Auth.auth().createUser(withEmail: login, password: password) {[weak self] authResult, error in
                if let error {
                    print(error.localizedDescription)
                    return
                }
                
                if let _ = authResult?.user {
                    self?.dismiss(animated: true)
                }
                
            }
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
