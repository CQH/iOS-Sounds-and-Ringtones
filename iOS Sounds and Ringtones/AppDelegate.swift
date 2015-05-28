//
//  AppDelegate.swift
//  System Sounds Library
//
//  Created by Carleton Hall on 5/20/15.
//  Copyright (c) 2015 Carleton Hall. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    /**User's bookmarked sound files*/
    var bookmarkedFiles: [String] = []
    
    /**Audio player responsible for playing sound files.*/
    var player: AVAudioPlayer = AVAudioPlayer()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
}

