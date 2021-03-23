//
//  ProfileViewController.swift
//  LingoChat
//
//  Created by Егор on 15.03.2021.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    //MARK: - Properties -
    
    var viewModel: ProfileViewModelProtocol
    
    //MARK: Subviews
    
    
    private lazy var userNameTextField = UITextField(placeholder: "Name")
    private lazy var phoneTextField = UITextField(placeholder: "Phone")
    private lazy var locationTextField = UITextField(placeholder: "Location")
    private lazy var bioTextField = UITextField(placeholder: "Bio")
    
    
    private lazy var userNameLabel = UILabel(font: UIFont.systemFont(ofSize: 17.0, weight: .semibold), textAlignment: .right)
    private lazy var phoneLabel = UILabel(font: UIFont.systemFont(ofSize: 17.0, weight: .semibold), textAlignment: .right)
    private lazy var locationLabel = UILabel(font: UIFont.systemFont(ofSize: 17.0, weight: .semibold), textAlignment: .right)
    private lazy var bioLabel = UILabel(font: UIFont.systemFont(ofSize: 17.0, weight: .semibold), textAlignment: .right)
    
    
    
    let imagePickerController = UIImagePickerController()
    
    
    
    private lazy var containerView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 5.0
        view.layer.shadowOffset = .zero
        
        return view
    }()
    
    
    
    private lazy var avatarImageView: UIImageView = {
        
        let image = UIImageView(image: UIImage(systemName: "person.fill"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        containerView.addSubview(image)
        
        return image
    }() 
    
    
    
    private lazy var openPhotoLibraryButton: UIButton = {
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        button.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.backgroundColor = .primaryColor
        containerView.addSubview(button)
        
        button.addAction(UIAction(handler: { action in
            
            self.choosePhotoActionSheet()
            
        }), for: .touchUpInside)
        
        return button
    }()
    
    
    
    private lazy var textFieldsStackView: UIStackView = {
        
        let stackView = UIStackView(arrangedSubviews: [userNameTextField, phoneTextField, locationTextField, bioTextField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5.0
        containerView.addSubview(stackView)
        
        return stackView
    }()
    
    
    
    
    private lazy var labelsStackView: UIStackView = {
        
        let stackView = UIStackView(arrangedSubviews: [userNameLabel, phoneLabel, locationLabel, bioLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5.0
        containerView.addSubview(stackView)
        
        return stackView
    }()
    
    
    
    
    //MARK: - Init -
    
    
    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Lifecycle -
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.9679402709, green: 0.964915216, blue: 0.9647199512, alpha: 1)
        title = "My Profile"
        
        imagePickerController.delegate = self
        userNameTextField.delegate = self
        phoneTextField.delegate = self
        locationTextField.delegate = self
        bioTextField.delegate = self
        
        
        view.addSubview(containerView)
        setTabBarItem()
        setupLayout()
        setupProfileViewModelObserver()
        
        viewModel.getDataProfile()
        
        viewModel.getUserAvatarImageURL { url in
            
            if let url = url {
                self.avatarImageView.setImage(from: url)
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        avatarImageView.roundCorners(self.avatarImageView.bounds.size.height / 2.0)
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        openPhotoLibraryButton.roundCorners(openPhotoLibraryButton.bounds.size.height / 2.0)
        avatarImageView.roundCorners(avatarImageView.bounds.size.height / 2.0)
        
        
        textFieldsStackView.arrangedSubviews.forEach { view in
            
            view.addBorder(side: .bottom, thickness: 4.0, color: #colorLiteral(red: 0.9830254912, green: 0.976836741, blue: 0.9766126275, alpha: 1))
        }
        
        labelsStackView.arrangedSubviews.forEach { view in
            
            view.addBorder(side: .bottom, thickness: 4.0, color: #colorLiteral(red: 0.9830254912, green: 0.976836741, blue: 0.9766126275, alpha: 1))
        }
    }
    
    
    
    
    //MARK: - Methods -
    
    
    private func setupProfileViewModelObserver() {
        
        viewModel.dataProfile.bind { [weak self] userProfileData in
            
            DispatchQueue.main.async {
                
                self?.userNameLabel.text = userProfileData?[.userName]
                self?.bioLabel.text = userProfileData?[.bio]
                self?.phoneLabel.text = userProfileData?[.phone]
                self?.locationLabel.text = userProfileData?[.location]
            }
        }
    }
    
    
    
    private func showBarButtonItems() {
        
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonDidTap))
        let unDoBarButtonItem = UIBarButtonItem(barButtonSystemItem: .undo, target: self, action: #selector(unDoButtonDidTap))
        
        self.tabBarController?.navigationItem.rightBarButtonItems = [doneBarButtonItem, unDoBarButtonItem]
    }
    
    
    @objc
    private func doneButtonDidTap() {
        
        if viewModel.isChanged {
            
            viewModel.dataProfile.value?[.userName] = userNameLabel.text
            viewModel.dataProfile.value?[.phone] = phoneLabel.text
            viewModel.dataProfile.value?[.location] = locationLabel.text
            viewModel.dataProfile.value?[.bio] = bioLabel.text
            
            updateAvatarImage(image: avatarImageView.image)
            viewModel.updateProfile()
            
            viewModel.isChanged = false
            view.endEditing(true)
        }
        tabBarController?.navigationItem.rightBarButtonItems = nil
    }
    
    
    @objc
    private func unDoButtonDidTap() {
        
        if viewModel.isChanged {
            
            userNameLabel.text = viewModel.dataProfile.value?[.userName]
            phoneLabel.text = viewModel.dataProfile.value?[.phone]
            locationLabel.text = viewModel.dataProfile.value?[.location]
            bioLabel.text = viewModel.dataProfile.value?[.bio]
            
            viewModel.isChanged = false
            view.endEditing(true)
        }
        tabBarController?.navigationItem.rightBarButtonItems = nil
    }
    
    
    
    private func updateAvatarImage(image: UIImage?) {
        
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else { return }
        viewModel.uploadAvatarImage(ImageData: imageData)
    }
    
    
    
    private func choosePhotoActionSheet() {
        
        let actionSheet = UIAlertController(title: "Photo source", message: "Choose a photo source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true, completion: nil)
                
            } else {
                
                let alert = UIAlertController(title: "Camera not available", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }))
        
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { action in
            
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
            
        }))
        
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
            
            
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    
    private func setTabBarItem() {
        
        let image = UIImage(systemName: "person.fill")
        let tabBarItem = UITabBarItem(title: nil, image: image, selectedImage: nil)
        
        self.tabBarItem = tabBarItem
    }
    
    
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            containerView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.9),
            
            
            avatarImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: view.bounds.size.height * 0.1),
            avatarImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.3),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            
            openPhotoLibraryButton.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            openPhotoLibraryButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.1),
            openPhotoLibraryButton.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.1),
            openPhotoLibraryButton.rightAnchor.constraint(equalTo: avatarImageView.rightAnchor),
            
            textFieldsStackView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 30.0),
            textFieldsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8.0),
            textFieldsStackView.trailingAnchor.constraint(equalTo: labelsStackView.leadingAnchor),
            textFieldsStackView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.3),
            
            
            labelsStackView.centerYAnchor.constraint(equalTo: textFieldsStackView.centerYAnchor),
            labelsStackView.heightAnchor.constraint(equalTo: textFieldsStackView.heightAnchor),
            labelsStackView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8.0),
            labelsStackView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.6)
        ])
    }
}


//MARK: - Extension -


extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        avatarImageView.image = image
        avatarImageView.clipsToBounds = true
        self.dismiss(animated: true, completion: nil)
        
        if navigationItem.rightBarButtonItems == nil {
            showBarButtonItems()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}



extension ProfileViewController: UITextFieldDelegate {
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text {
            
            if !text.isEmpty {
                
                if !viewModel.isChanged {
                 
                    viewModel.isChanged = true
                }
                
                if navigationItem.rightBarButtonItems == nil {
                    
                    showBarButtonItems()
                }
            }
        }
        return true
    }
    
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
                
        if textField === userNameTextField {
            
            userNameLabel.text = textField.text
        }
        
        if textField === phoneTextField {
            
            phoneLabel.text = textField.text
        }
        
        if textField === locationTextField {
            
            locationLabel.text = textField.text
        }
        
        if textField === bioTextField {
            
            bioLabel.text = textField.text
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = ""
    }
}
