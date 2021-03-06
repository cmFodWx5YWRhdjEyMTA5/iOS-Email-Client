//
//  ContactManager.swift
//  Criptext Secure Email
//
//  Created by Gianni Carlo on 5/19/17.
//  Copyright © 2017 Criptext Inc. All rights reserved.
//

import Foundation
import Contacts

class ContactUtils {
    static let store = CNContactStore()
        
    private class func parseContact(_ contactString: String) -> Contact {
        let contactMetadata = self.getStringEmailName(contact: contactString);
        guard let existingContact = DBManager.getContact(contactMetadata.0) else {
            let newContact = Contact(value: ["displayName": contactMetadata.1, "email": contactMetadata.0])
            DBManager.store([newContact])
            return newContact
        }
        let isNewNameFromEmail = contactMetadata.0.starts(with: contactMetadata.1)
        if (!isNewNameFromEmail && contactMetadata.1 != existingContact.displayName) {
            DBManager.update(contact: existingContact, name: contactMetadata.1)
        }
        return existingContact
    }
    
    class func parseEmailContacts(_ contacts: [String], email: Email, type: ContactType){
        contacts.forEach { (contactString) in
            let contact = parseContact(contactString)
            let emailContact = EmailContact()
            emailContact.contact = contact
            emailContact.email = email
            emailContact.type = type.rawValue
            emailContact.compoundKey = "\(email.key):\(contact.email):\(type.rawValue)"
            DBManager.store([emailContact])
        }
    }
    
    class func prepareContactsStringArray(contactsString: String?) -> [String]{
        guard let contactsString = contactsString else {
            return [String]()
        }
        let stringArray = contactsString.split(separator: ",")
        return concatEmailAddresses(stringArray: stringArray, index: 0, result: [String](), remnant: "")
    }
    
    private class func concatEmailAddresses(stringArray: [Substring], index: Int, result: [String], remnant: String) -> [String] {
        guard index < stringArray.count else {
            return result
        }
        let contactString = remnant + stringArray[index]
        if (contactString.contains("@")) {
            return concatEmailAddresses(stringArray: stringArray, index: index+1, result: result + [contactString], remnant: "")
        }
        return concatEmailAddresses(stringArray: stringArray, index: index+1, result: result, remnant: "\(contactString),")
    }
    
    class func getStringEmailName(contact: String) -> (String, String) {
        let cleanContact = contact.replacingOccurrences(of: "\"", with: "")
        let myContact = NSString(string: cleanContact)
        let pattern = "<(.*?)>"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.matches(in: cleanContact, options: [], range: NSRange(location: 0, length: myContact.length))
        let email = (matches.last != nil ? myContact.substring(with: matches.last!.range(at: 1)) : String(myContact)).lowercased()
        let name = matches.last != nil && cleanContact.split(separator: "<").count > 1 ? cleanContact.prefix(matches.last!.range.location) : email.split(separator: "@")[0]
        return (email, String(name.trimmingCharacters(in: .whitespacesAndNewlines)))
    }
}
