import UIKit

final class ProfileViewController: UIViewController {
    
    //MARK: - Properties -
    
    var viewModel: ProfileViewModelProtocol
    
    
    //MARK: subviews
    
    private lazy var usernameTextField = UITextField(placeholder: NSLocalizedString(
                                                        "ProfileViewController.usernameTextField".localized,
                                                        comment: ""))
    
    private lazy var phoneTextField = UITextField(placeholder: NSLocalizedString(
                                                    "ProfileViewController.phoneTextField".localized,
                                                    comment: ""))
    
    private lazy var locationTextField = UITextField(placeholder: NSLocalizedString(
                                                        "ProfileViewController.locationTextField".localized,
                                                        comment: ""))
    
    private lazy var bioTextField = UITextField(placeholder: NSLocalizedString(
                                                    "ProfileViewController.bioTextField".localized,
                                                    comment: ""))
    
    
    private lazy var usernameLabel = UILabel(font: UIFont.systemFont(ofSize: 17.0,
                                                                     weight: .semibold),
                                             textAlignment: .right)
    
    private lazy var phoneLabel = UILabel(font: UIFont.systemFont(ofSize: 17.0,
                                                                  weight: .semibold),
                                          textAlignment: .right)
    
    private lazy var locationLabel = UILabel(font: UIFont.systemFont(ofSize: 17.0,
                                                                     weight: .semibold),
                                             textAlignment: .right)
    
    private lazy var bioLabel = UILabel(font: UIFont.systemFont(ofSize: 17.0,
                                                                weight: .semibold),
                                        textAlignment: .right)
    
    
    
    let imagePickerController = UIImagePickerController()
    
    
    
    private lazy var containerView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 5.0
        view.layer.shadowOffset = .zero
        
        return view
    }()
    
    
    
    private lazy var avatarImageView: MyImageView = {
        
        let image = MyImageView(image: UIImage(systemName: "person.fill"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        image.contentMode = .scaleToFill
        image.layer.masksToBounds = false
        containerView.addSubview(image)
        image.didSetImageBlock = { _ in
            self.avatarImageView.layer.masksToBounds = true
        }
        
        return image
    }() 
    
    
    
    private lazy var openPhotoLibraryButton: UIButton = {
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        button.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.backgroundColor = ThemeManager.shared.primaryColor
        containerView.addSubview(button)
        
        button.addAction(UIAction(handler: { action in
            
            self.choosePhotoActionSheet()
            
        }), for: .touchUpInside)
        
        return button
    }()
    
    
    
    private lazy var textFieldsStackView: UIStackView = {
        
        let stackView = UIStackView(arrangedSubviews: [usernameTextField, phoneTextField, locationTextField, bioTextField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5.0
        containerView.addSubview(stackView)
        
        return stackView
    }()
    
    
    
    
    private lazy var labelsStackView: UIStackView = {
        
        let stackView = UIStackView(arrangedSubviews: [usernameLabel, phoneLabel, locationLabel, bioLabel])
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
        tabBarItem.image = UIImage(systemName: "person.fill")
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        ThemeManager.shared.removeObserver(self)
    }
    
    
    //MARK: - Lifecycle -
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        ThemeManager.shared.addObserver(self)
        
        imagePickerController.delegate = self
        usernameTextField.delegate = self
        phoneTextField.delegate = self
        locationTextField.delegate = self
        bioTextField.delegate = self
        
        view.addSubview(containerView)
        setLocalizedText()
        setupLayout()
        setupProfileViewModelObserver()
        
        viewModel.observeDataProfile()
        
        
        DispatchQueue.main.async {
            
            self.viewModel.getUserAvatarImageURL { url in
                
                if let url = url {
                    self.avatarImageView.setImage(from: url)
                }
            }
        }
    }
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        avatarImageView.roundCorners(self.avatarImageView.bounds.size.height / 2.0)
        openPhotoLibraryButton.roundCorners(openPhotoLibraryButton.bounds.size.height / 2.0)
        view.window?.overrideUserInterfaceStyle = UserDefaults.standard.interfaceStyle

    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //    openPhotoLibraryButton.roundCorners(openPhotoLibraryButton.bounds.size.height / 2.0)
        //   avatarImageView.roundCorners(avatarImageView.bounds.size.height / 2.0)
        
        
        textFieldsStackView.arrangedSubviews.forEach { view in
            
            view.addBorder(side: .bottom, thickness: 4.0, color: .secondarySystemBackground)
        }
        
        labelsStackView.arrangedSubviews.forEach { view in
            
            view.addBorder(side: .bottom, thickness: 4.0, color: .secondarySystemBackground)
        }
    }
    
    
    
    
    //MARK: - Methods -
    
    
    private func setupProfileViewModelObserver() {
        
        viewModel.user.bind { [weak self] user in
            
            self?.usernameLabel.text = user?.username
            self?.phoneLabel.text = user?.phone
            self?.bioLabel.text = user?.bio
            self?.locationLabel.text = user?.location
            
        }
    }
    
    
    
    private func setLocalizedText() {
        
        LanguageManager.shared.didChangeLangBlocks.append {
            
            self.usernameTextField.placeholder = NSLocalizedString("ProfileViewController.usernameTextField".localized,
                                                                   comment: "")
            self.phoneTextField.placeholder = NSLocalizedString("ProfileViewController.phoneTextField".localized,
                                                                comment: "")
            self.locationTextField.placeholder = NSLocalizedString("ProfileViewController.locationTextField".localized,
                                                                   comment: "")
            self.bioTextField.placeholder = NSLocalizedString("ProfileViewController.bioTextField".localized,
                                                              comment: "")
        }
    }
    
    
    
    private func showBarButtonItems() {
        
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                target: self,
                                                action: #selector(doneButtonDidTap))
        
        let unDoBarButtonItem = UIBarButtonItem(barButtonSystemItem: .undo,
                                                target: self,
                                                action: #selector(unDoButtonDidTap))
        
        self.tabBarController?.navigationItem.rightBarButtonItems = [doneBarButtonItem, unDoBarButtonItem]
    }
    
    
    @objc
    private func doneButtonDidTap() {
        
        if viewModel.isChanged {
            
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
            
            viewModel.user.value = viewModel.oldModelUser
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
        
        let sheetTitle = NSLocalizedString("SettingViewController.ChoosePhoto.ActionSheet.title", comment: "")
        let sheetMessage = NSLocalizedString("SettingViewController.ChoosePhoto.ActionSheet.message", comment: "")
        
        let actionSheet = UIAlertController(title: sheetTitle,
                                            message: sheetMessage,
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("SettingViewController.ChoosePhoto.Action.Camera",comment: ""),
                                            style: .default,
                                            
                                            handler: { action in
                                                
                                                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                                    
                                                    self.imagePickerController.sourceType = .camera
                                                    self.present(self.imagePickerController, animated: true, completion: nil)
                                                    
                                                } else {
                                                    
                                                    let alert = UIAlertController(title:NSLocalizedString("SettingViewController.ChoosePhoto.Alert.Error.NotAvailable", comment: ""),
                                                                                  message: nil,
                                                                                  preferredStyle: .alert)
                                                    
                                                    
                                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                                    self.present(alert, animated: true, completion: nil)
                                                }
                                            }))
        
        
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("SettingViewController.ChoosePhoto.Action.PhotoLibrary", comment: ""),
                                            style: .default,
                                            handler: { action in
                                                
                                                self.imagePickerController.sourceType = .photoLibrary
                                                self.present(self.imagePickerController, animated: true, completion: nil)
                                                
                                            }))
        
        
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("SettingViewController.ChoosePhoto.Action.Cancel", comment: ""),
                                            style: .cancel,
                                            handler: { action in
                                                
                                                print("Cancel")
                                                
                                            }))
        
        self.present(actionSheet, animated: true, completion: nil)
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
        self.dismiss(animated: true, completion: nil)
        
        if navigationItem.rightBarButtonItems == nil {
            viewModel.isChanged = true
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
        
        guard let text = textField.text else { return true }
        
        if !text.isEmpty {
            
            if textField === usernameTextField {
                
                viewModel.user.value?.username = text
            }
            
            if textField === phoneTextField {
                
                viewModel.user.value?.phone = text
            }
            
            if textField === locationTextField {
                
                viewModel.user.value?.location = text
            }
            
            if textField === bioTextField {
                
                viewModel.user.value?.bio = text
            }
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let text = textField.text else { return }
        
        if !text.isEmpty {
            
            textField.text = ""
        }
    }
}


extension ProfileViewController: ThemeObserver {
    
    func didChangePrimaryColor(_ color: UIColor) {
        
        openPhotoLibraryButton.backgroundColor = color
    }
}
