//
//  MessageView.swift
//  QuikScan
//
//  Created by Kailash on 30/03/24.
//

import SwiftUI
import MessageUI

struct MessageComposerView: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    let recipient: String
    let messageBody: String
    
    func makeCoordinator() -> MessageCoordinator {
        return MessageCoordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let messageComposer = MFMessageComposeViewController()
        messageComposer.recipients = [recipient]
        messageComposer.body = messageBody
        messageComposer.messageComposeDelegate = context.coordinator
        return messageComposer
    }
    
    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {
        // Update the view controller if needed
    }
}

class MessageCoordinator: NSObject, MFMessageComposeViewControllerDelegate {
    let parent: MessageComposerView
    
    init(parent: MessageComposerView) {
        self.parent = parent
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        parent.isShowing = false
    }
}


struct MessageView: View {
    @Binding var messageData: SMSMessage?
    @Binding var isSMSViewVisible: Bool
    var body: some View {
        NavigationStack {
            VStack {
                if let messageData = messageData {
                    MessageComposerView(isShowing: $isSMSViewVisible,
                                        recipient: messageData.phoneNumber,
                                        messageBody: messageData.message)
                }
            }
            .padding()
        }
        
    }
}

#Preview {
    MessageView(messageData: .constant(nil), isSMSViewVisible: .constant(false))
}
