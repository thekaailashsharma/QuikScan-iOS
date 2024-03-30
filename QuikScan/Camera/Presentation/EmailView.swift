//
//  EmailView.swift
//  QuikScan
//
//  Created by Kailash on 30/03/24.
//

import SwiftUI
import MessageUI

struct EmailComposerView: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    let address: String
    let subject: String
    let messageBody: String
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposer = MFMailComposeViewController()
        mailComposer.setToRecipients([address])
        mailComposer.setSubject(subject)
        mailComposer.setMessageBody(messageBody, isHTML: true)
        mailComposer.mailComposeDelegate = context.coordinator
        return mailComposer
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
        // Update the view controller if needed
    }
}

class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
    let parent: EmailComposerView
    
    init(parent: EmailComposerView) {
        self.parent = parent
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        parent.isShowing = false
    }
}


struct EmailView: View {
    @Binding var emailData: Email?
    @Binding var isEmailViewVisible: Bool
    var body: some View {
        NavigationStack {
            VStack {
                if let emailData = emailData, let body = emailData.body, let subject = emailData.subject {
                    EmailComposerView(
                        isShowing: $isEmailViewVisible,
                        address: emailData.address,
                        subject: subject,
                        messageBody: body
                    )
                }
            }
            .padding()
        }
        
    }
}

#Preview {
    EmailView(emailData: .constant(nil), isEmailViewVisible: .constant(false))
}
