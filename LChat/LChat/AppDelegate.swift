import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var authListener: AuthStateDidChangeListenerHandle?
 //   var navController = UINavigationController()
    var appCoordinator = AppCoordinator(navController: UINavigationController())
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
         startListenAuthChanges()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}



extension AppDelegate {
    
    
    func stopListenAuthChanges() {
        
        guard let listener = authListener else { assertionFailure(); return }
        
        Auth.auth().removeStateDidChangeListener(listener)
    }
    
    
    
    func startListenAuthChanges() {
        
        authListener = Auth.auth().addStateDidChangeListener({ auth, user in
            
            if user == nil {

                self.appCoordinator.isLoggedIn = false
                self.appCoordinator.start()

            } else {
              
             // try! Auth.auth().signOut()
                print("usr", Auth.auth().currentUser)
                print(Auth.auth().currentUser?.displayName)
                
                    
                self.appCoordinator.isLoggedIn = true
                self.appCoordinator.start()
            }
        })
    }
}

