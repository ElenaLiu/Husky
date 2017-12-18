//
//  LoginManager.swift
//  Husky
//
//  Created by 劉芳瑜 on 2017/12/15.
//  Copyright © 2017年 Fang-Yu. Liu. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import UIKit

struct NetworkingService {
    
    var databaseRef: DatabaseReference! {
        return Database.database().reference()
    }
    
    var storageRef: StorageReference {
        return Storage.storage().reference()
    }
    
    // Reset Password
    func resetPassword(email: String){
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            if error == nil {
                print("An email with information on how to reset your password has been sent to you. thank You")
            }else {
                print(error!.localizedDescription)
            }
        })
    }
    
    // 1 ---- We create the User
    
    func signUp(email: String,
                username: String,
                password: String,
                data: Data!)
    {
        Auth.auth().createUser(withEmail: email,
                               password: password,
                               completion: { (user, error) in
            if error == nil {
                self.setUserInfo(user: user,
                                 username: username,
                                 password: password,
                                 data: data)
            }else {
                print(error!.localizedDescription)
            }
        })
    }
    
    // 2 ------ Set User Info
    
    private func setUserInfo(user: User!,
                             username: String,
                             password: String,
                             data: Data!)
    {
        
        //Create Path for the User Image
        let imagePath = "profileImage\(user.uid)/userPic.jpg"
        
        // Create image Reference
        let imageRef = storageRef.child(imagePath)
        
        // Create Metadata for the image
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        // Save the user Image in the Firebase Storage File
        imageRef.putData(data as Data,
                         metadata: metaData) { (metaData, error) in
            if error == nil {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = username
                changeRequest.photoURL = metaData!.downloadURL()
                changeRequest.commitChanges(completion: { (error) in
                    if error == nil {
                        self.saveInfo(user: user,
                                      username: username,
                                      password: password)
                    }else{
                        print(error!.localizedDescription)
                    }
                })
            }else {
                print(error!.localizedDescription)
            }
        }
    }
    
    // 3 --- Saving the user Info in the database
    private func saveInfo(user: User!,
                          username: String,
                          password: String)
    {
        
        // Create our user dictionary info\
        let userInfo = ["email": user.email!,
                        "username": username,
                        "uid": user.uid,
                        "photoUrl": String(describing: user.photoURL!)]
        
        // create user reference
        let userRef = databaseRef.child("Users").child(user.uid)
        
        // Save the user info in the Database
        userRef.setValue(userInfo)
        
        // Signing in the user
        signIn(email: user.email!,
               password: password)
    }
    
    // 4 ---- Signing in the User
    func signIn(email: String, password: String){
        Auth.auth().signIn(withEmail: email,
                           password: password,
                           completion: { (user, error) in
            if error == nil {
                if let user = user {
                    print("\(user.displayName!) has signed in succesfully!")
                    
                    let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDel.logUser()
                }
            }else {
                print(error!.localizedDescription)
            }
        })
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        }catch {
            print("logOut error")
        }
        
    }
    
}
