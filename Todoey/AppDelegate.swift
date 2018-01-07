//
//  AppDelegate.swift
//  Todoey
//
//  Created by Bryan Heshiki on 12/20/17.
//  Copyright © 2017 Bryan Heshiki. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //first thing that happens when app gets opens- before ViewdidLoad()
       
       print(Realm.Configuration.defaultConfiguration.fileURL)
        
    
        do {
           _ = try Realm()
        } catch {
            print("error catching new realm, \(error)")
        }
        return true

}

}
