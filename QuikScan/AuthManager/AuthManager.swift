//
//  AuthManager.swift
//  QuikScan
//
//  Created by Kailash on 29/03/24.
//

import SwiftUI
import FirebaseAuth

class AuthManager : ObservableObject {
    static let shared = AuthManager()
    private let auth = Auth.auth()
    @Published var currentUser: User? = Auth.auth().currentUser
    @Published var isLoggedIn: Bool = false
    private var verificationId: String?
    
    public func startAuth(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        PhoneAuthProvider.provider()
          .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
              Auth.auth().settings?.isAppVerificationDisabledForTesting = true
              guard let verificationId = verificationID, error == nil else {
                  print("my error is \(String(describing: error))")
                  completion(false)
                  return
              }
              self?.verificationId = verificationId
              completion(true)
          }
        
    }
    
    public func signOut() {
        try? Auth.auth().signOut()
        getLoginStatus()
        isLoggedIn = true
    }
    
    public func getLoginStatus() {
        if Auth.auth().currentUser == nil {
            print("Login Status = \(Auth.auth().currentUser)")
            isLoggedIn = true
        } else {
            print("Login Status = \(Auth.auth().currentUser)")
            isLoggedIn = false
        }
    }
    
    public func verifyCode(smsCode: String, completion: @escaping (Bool) -> Void) {
        
        guard let verificationId = verificationId else {
           
            completion(false)
            return
        }
        let credential = PhoneAuthProvider.provider().credential(
          withVerificationID: verificationId,
          verificationCode: smsCode
        )
        
        Auth.auth().signIn(with: credential) {[weak self] authResult, error in
            guard authResult != nil, error == nil else {
                print("my error1 is \(String(describing: error))")
                completion(false)
                return
            }
            self?.isLoggedIn = true
            completion(true)
        }
    }
}
