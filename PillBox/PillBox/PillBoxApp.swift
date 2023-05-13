//
//  PillBoxApp.swift
//  PillBox
//
//  Created by Максим Троицкий
//

import SwiftUI

@main
struct PillBoxApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            if UserDefaults.standard.string(forKey: "UserPhoneNumber") != "" &&
                UserDefaults.standard.string(forKey: "UserBirthday") != "" &&
                UserDefaults.standard.string(forKey: "UserSurname") != "" &&
                UserDefaults.standard.string(forKey: "UserName") != "" &&
                UserDefaults.standard.string(forKey: "UserPhoneNumber") != nil &&
                UserDefaults.standard.string(forKey: "UserBirthday") != nil &&
                UserDefaults.standard.string(forKey: "UserSurname") != nil &&
                UserDefaults.standard.string(forKey: "UserName") != nil {
                ContentView()
            } else {
                startView()
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.all
    
    func application(_ applicatiom: UIApplication, supportedInterfaceOrientationsFor: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
