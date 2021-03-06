//
//  Account.swift
//  iOS-Email-Client
//
//  Created by Pedro Aim on 3/5/18.
//  Copyright © 2018 Criptext Inc. All rights reserved.
//

import Foundation
import RealmSwift

class Account: Object{
    @objc dynamic var username = ""
    @objc dynamic var deviceId = 1
    @objc dynamic var name = ""
    @objc dynamic var jwt = ""
    @objc dynamic var identityB64 = ""
    @objc dynamic var regId : Int32 = 0
    @objc dynamic var signature = ""
    @objc dynamic var signatureEnabled = false
    @objc dynamic var lastTimeFeedOpened = Date()
    
    override static func primaryKey() -> String? {
        return "username"
    }
    
    class func create(from signupData: SignUpData) -> Account {
        let myAccount = Account()
        myAccount.username = signupData.username
        myAccount.name = signupData.fullname
        myAccount.jwt = signupData.token!
        myAccount.regId = signupData.getRegId()
        myAccount.identityB64 = signupData.getIdentityKeyPairB64() ?? ""
        myAccount.deviceId = signupData.deviceId
        return myAccount
    }
}
