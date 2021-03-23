//
//  ProfileViewModel.swift
//  LingoChat
//
//  Created by Егор on 15.03.2021.
//

import Foundation
import Firebase

protocol ProfileViewModelProtocol {
    
    var dataProfile: Bindable<[UserProperty: String]> { get set }
    var isChanged: Bool { get set }
    
    func uploadAvatarImage(ImageData data: Data)
    func getUserAvatarImageURL(completion: @escaping (URL?) -> ())
    func getDataProfile()
    func updateProfile()
}


final class ProfileViewModel: ProfileViewModelProtocol {
    
    //MARK: - Properties -
    
    private let storageService: FBStorageServiceProtocol
    private let observeService: FBObserveServiceProtocol
    private let writeService: FBWriteServiceProtocol
    
    private let currentUserId = Auth.auth().currentUser?.uid

    var dataProfile = Bindable<[UserProperty : String]>()
    var isChanged = false

    
    
    //MARK: - Init -
    
    init(storageService: FBStorageServiceProtocol,
         observeService: FBObserveServiceProtocol,
         writeService: FBWriteServiceProtocol) {
        
        self.storageService = storageService
        self.observeService = observeService
        self.writeService = writeService
        
        self.dataProfile.value = [:]
    }
    
    
    //MARK: - Methods -
    
    
    func set(newValue: String, profileDataKey key: UserProperty) {
        
        switch key {
        
        case .userName:
            dataProfile.value?[.userName] = newValue
            
        case .phone:
            dataProfile.value?[.phone] = newValue
            
        case .location:
            dataProfile.value?[.location] = newValue
            
        case .bio:
            dataProfile.value?[.bio] = newValue
            
        default:
            break
        }
    }
    
    
    
    func updateProfile() {
        
        if let data = dataProfile.value {
         
            if !data.isEmpty && isChanged {
                
                if let id = currentUserId {
                     
                    data.forEach { key, value in
                        print(key, value)
                        writeService.write(data: value, in: "\(FirebasePath.Path.users.rawValue)/\(id)/\(key)") { error in
                         
                            if let error = error {
                             
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    func getDataProfile() {
        
        if let currentUserId = Auth.auth().currentUser?.uid {
         
            observeService.setObserve(for: "\(FirebasePath.Path.users.rawValue)/\(currentUserId)") { [weak self] data in
                             
                guard let userName = data?["userName"],
                      let phone = data?["phone"],
                      let bio = data?["bio"],
                      let location = data?["location"] else { assertionFailure()
                                                                                 return }
                
                
                self?.dataProfile.value?[.userName] = userName
                self?.dataProfile.value?[.phone] = phone
                self?.dataProfile.value?[.bio] = bio
                self?.dataProfile.value?[.location] = location
            }
        }
    }
    
    
    
    func getUserAvatarImageURL(completion: @escaping (URL?) -> ()) {
        
        if let currentUserId = Auth.auth().currentUser?.uid {
                        
            self.storageService.getURL(from: "avatars/\(currentUserId)") { result in
                
                switch result {
                
                case .failure(let error):
                    
                    print(error.localizedDescription)
                    completion(nil)
                    
                case .success(let url):
                    
                    completion(url)
                }
            }
        }
    }
    
    
    func uploadAvatarImage(ImageData data: Data) {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        self.storageService.upload(data: data, path: "avatars/\(currentUserId)")
    }
}
