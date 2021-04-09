//
//  ChatViewController+DataSource.swift
//  LChat
//
//  Created by Егор on 04.04.2021.
//

import Foundation
import MessageKit

extension ChatViewController: MessagesDataSource {
    
    
    func currentSender() -> SenderType {
    
        if let user = self.viewModel.currentUser {
            
            return Sender(senderId: user.id, displayName: user.username)
            
        } else {
            
            assertionFailure()
            return Sender(senderId: "", displayName: "")
        }
    }
    
    
    
    func isFromCurrentSender(message: MessageType) -> Bool {
    
        return true
    }
    
    
    
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        messages[indexPath.section]
    }
    
    
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        let attributes = [NSAttributedString.Key.foregroundColor : UIColor.gray,
                          NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11.0, weight: .medium)]
        
        let date = messages[indexPath.section].date
        let format = "yyyy-MM-dd HH:mm"
        let formatter = DateFormatter()
        
        
        if formatter.isToday(date: date, withFormat: format) {
            
            if let convertedStrDateToHour = formatter.convertDate(string: date, fromFormat: format, toFormat: "HH:mm") {
                
                return  NSAttributedString(string: convertedStrDateToHour, attributes: attributes)
            }
        }
        
        if formatter.isYesterday(date: date, format: format),
           let convertedStrDate = formatter.convertDate(string: date, fromFormat: format, toFormat: "HH:mm") {
            
            let text = "yesterday \(convertedStrDate)"
            return  NSAttributedString(string: text, attributes: attributes)
            
        } else {
            
            let convertedStrDate = formatter.convertDate(string: date, fromFormat: format, toFormat: "MMM dd HH:mm")
            
            return  NSAttributedString(string: convertedStrDate!, attributes: attributes)
        }
    }
}
