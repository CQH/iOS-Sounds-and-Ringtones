//
//  FilesTableViewController.swift
//  iOS Sounds and Ringtones
//
//  Created by Carleton Hall on 10/15/16.
//  Copyright © 2016 Carleton Hall. All rights reserved.
//

import UIKit
import AVFoundation

class FilesTableViewController: UITableViewController {
    // MARK: - Class Variables
    
    ///App Controller singleton
    let appController = AppController.sharedInstance()
    
    ///The directory where sound files are located.
    var directory: NSDictionary!
    
    ///The files in the directory
    var files: [String] = []
    
    // MARK: - View Controller Setup
    override func viewDidLoad() {
        super.viewDidLoad()
		if #available(iOS 11.0, *) {
			self.navigationItem.largeTitleDisplayMode = .always
		}
        files = directory["files"] as! [String]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appController.userDefaults.synchronize()
        if let bookmarks: [String] = appController.userDefaults.object(forKey: "bookmarkedSoundFiles") as? [String] {
            appController.bookmarkedFiles = bookmarks
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        appController.userDefaults.set(appController.bookmarkedFiles, forKey: "bookmarkedSoundFiles")
        appController.userDefaults.synchronize()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return directory["path"] as? String
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dir: String = directory["path"] as! String
        let fileName: String = files[indexPath.row]
        let filePath: String = "\(dir)/\(fileName)"
        let cell = tableView.dequeueReusableCell(withIdentifier: "sound", for: indexPath) as! SoundTableViewCell
        
        cell.fileNameLabel.text = fileName
        cell.filePathLabel.text = filePath
        return cell
     }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Play the sound
        let dir: String = directory["path"] as! String
        let fileName: String = files[indexPath.row]
        let fileURL: URL = URL(fileURLWithPath: "\(dir)/\(fileName)")
        do {
            appController.audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            appController.audioPlayer.play()
        } catch {
            debugPrint("\(error)")
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let bookmarkAction: UITableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Bookmark" , handler: { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
            let dir: String = self.directory["path"] as! String
            let fileName: String = self.files[indexPath.row]
            let filePath: String = "\(dir)/\(fileName)"
            self.appController.bookmarkedFiles.append(filePath)
            tableView.setEditing(false, animated: true)
        })
        return [bookmarkAction]
    }
}
