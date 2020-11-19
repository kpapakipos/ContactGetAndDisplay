//
//  ContactsScreen.swift
//  ContactGetAndDisplay
//
//  Created by Keegan Papakipos on 11/18/20.
//

import UIKit
import Contacts

class ContactsScreen: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let contactStore = CNContactStore()
    var contacts = [CNContact]()
    
    @IBOutlet weak var contactsTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "ContactCell")) as? ContactCell
        let name = contacts[indexPath.row].nickname.count > 0 ? contacts[indexPath.row].nickname : "\(contacts[indexPath.row].givenName) \(contacts[indexPath.row].familyName)"
        cell?.name.text = name
        cell?.number.text = contacts[indexPath.row].phoneNumbers[0].value.stringValue
        return cell ?? ContactCell()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contactsTable.delegate = self
        self.contactsTable.dataSource = self
        
        let authStatus = CNContactStore.authorizationStatus(for: .contacts)
        switch authStatus {
        case .restricted:
            print("User cannot grant permission, e.g. parental controls in force.")
            exit(1)
        case .denied:
            print("User has explicitly denied permission.")
            print("They have to grant it via Preferences app if they change their mind.")
            exit(1)
        case .notDetermined:
            print("You need to request authorization via the API now.")
        case .authorized:
            print("You are already authorized.")
        @unknown default:
            print("default case happened- this is an error.")
            exit(1)
        }
        
        if authStatus == .notDetermined {
            contactStore.requestAccess(for: .contacts) { success, error in
                if !success {
                    print("Not authorized to access contacts. Error = \(String(describing: error))")
                    exit(1)
                }
                print("Authorized!")
            }
        }
        
        // Here, the contacts store is authorized for sure.
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName) as CNKeyDescriptor, CNContactNicknameKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)
        do {
            try self.contactStore.enumerateContacts(with: request) {
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                self.contacts.append(contact)
                print(contact)
            }
        } catch {
            print("unable to fetch contacts")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
