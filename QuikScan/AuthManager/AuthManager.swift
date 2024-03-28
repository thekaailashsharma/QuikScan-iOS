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
    private var verificationId: String?
    
    public func startAuth(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        PhoneAuthProvider.provider()
          .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
              Auth.auth().settings?.isAppVerificationDisabledForTesting = true
              guard let verificationId = verificationID, error == nil else {
                  print("my error is \(error)")
                  completion(false)
                  return
              }
              self?.verificationId = verificationId
              completion(true)
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
        
        Auth.auth().signIn(with: credential) { authResult, error in
            guard authResult != nil, error == nil else {
                print("my error1 is \(error)")
                completion(false)
                return
            }
            completion(true)
        }
    }
}
