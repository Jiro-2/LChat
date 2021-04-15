//
//  ChatViewController+Delegates.swift
//  LChat
//
//  Created by Егор on 04.04.2021.
//

import UIKit
import MessageKit
import InputBarAccessoryView


extension ChatViewController: SearchUserViewControllerDelegate {
    
    func viewController(_ viewController: UIViewController, foundUser user: User) {
        
        viewModel.interLocutor = user
        viewModel.isExistsChat()
    }
}


extension ChatViewController: ChatRoomsViewControllerDelegate {
    
    func viewController(_ viewController: ChatRoomsViewController, didSelect chat: Chat) {
        
        viewModel.messages.value = chat.messages
        viewModel.chatRoomId = chat.id
        viewModel.isDownloadedMessages = true
        viewModel.startObservingChat()
    }
}



extension ChatViewController: MessagesDisplayDelegate {
    
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        let borderColor: UIColor = isFromCurrentSender(message: message) ? .clear : .clear
        return .bubbleTailOutline(borderColor, corner, .pointedEdge)
    }
    
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 20.0
    }
}




extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        if !text.isEmpty {
            
            if let isChatExists = viewModel.isChatExists.value {
                
                if isChatExists {
                
                    viewModel.sendMessage(text: text)
                    
                } else {
                    
                    viewModel.startChat()
                    viewModel.sendMessage(text: text)
                }
            }
        }
    }
}




extension ChatViewController: MessagesLayoutDelegate {
    
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        let colorOfUserMessages = UIColor(red: 0.2815505862, green: 0.6601088643, blue: 0.6278207302, alpha: 1.0)
        let colorOfMemberMessages = UIColor(red: 0.9078431726, green: 0.9589278102, blue: 0.9659121633, alpha: 1)
        
        return  isFromCurrentSender(message: message) ? colorOfUserMessages : colorOfMemberMessages
    }
}
