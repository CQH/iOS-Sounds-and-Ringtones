//
//  DirectoriesTableViewController.swift
//  iOS Sounds and Ringtones
//
//  Created by Carleton Hall on 10/15/16.
//  Copyright © 2016 Carleton Hall. All rights reserved.
//

import UIKit

class DirectoriesTableViewController: UITableViewController {
    // MARK: - Class Variables
    
    ///App Controller singleton
    let appController = AppController.sharedInstance()
    
    ///File Manager allows us access to the device's files to which we are allowed.
    let fileManager: FileManager = FileManager()
    
    ///The directories where we will first start looking for files as well as sub directories.
    let rootSoundDirectories: [String] = ["/Library/Ringtones", "/System/Library/Audio/UISounds"]

    ///The directories where sound files are located.
    var directories: [NSMutableDictionary] = []
    
    ///The directory that we is passed to the listing view controller.
    var segueDirectory: NSDictionary!
    
    // MARK: - View Controller Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        for directory in rootSoundDirectories { //seed the directories we know about.
            let newDirectory: NSMutableDictionary = [
                "path" : "\(directory)",
                "files" : []
            ]
            directories.append(newDirectory)
        }
        getDirectories()
        getSoundFiles()
    }
    
    // MARK: - Class Functions
    /**
     Starting with the "/Library/Ringtones" & "/System/Library/Audio/UISounds" directories, it looks for other sub-directories just one level lower and saves their relative path in directories array.
     
     - URLs: All of the contents of the directory (files and sub-directories).
     */
    func getDirectories() {
        for directory in rootSoundDirectories {
            let directoryURL: URL = URL(fileURLWithPath: "\(directory)", isDirectory: true)
            do {
                var URLs: [URL]?
                URLs = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: [URLResourceKey.isDirectoryKey], options: FileManager.DirectoryEnumerationOptions())
                
                var urlIsaDirectory: ObjCBool = ObjCBool(false)
                for url in URLs! {
                    fileManager.fileExists(atPath: url.path, isDirectory: &urlIsaDirectory)
                    if urlIsaDirectory.boolValue {
                        let directory: String = "\(url.relativePath)"
                        let newDirectory: NSMutableDictionary = [
                            "path" : "\(directory)",
                            "files" : []
                        ]                        
                        directories.append(newDirectory)
                    }
                }
            } catch {
                debugPrint("\(error)")
            }
        }
    }
    
    
    /**
     For each directory, it looks at each item (file or directory) and only appends the sound files to the soundfiles[i]files array.
     
     - URLs: All of the contents of the directory (files and sub-directories).
     */
    func getSoundFiles() {
        for directory in directories {
            let directoryURL: URL = URL(fileURLWithPath: directory.value(forKey: "path") as! String, isDirectory: true)
            
            do {
                var URLs: [URL]?
                URLs = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: [URLResourceKey.isDirectoryKey], options: FileManager.DirectoryEnumerationOptions())
                var urlIsaDirectory: ObjCBool = ObjCBool(false)
                var soundPaths: [String] = []
                for url in URLs! {
                    fileManager.fileExists(atPath: url.path, isDirectory: &urlIsaDirectory)
                    if !urlIsaDirectory.boolValue {
                        soundPaths.append("\(url.lastPathComponent)")
                    }
                }
                directory["files"] = soundPaths
            } catch {
                debugPrint("\(error)")
            }
        }
    }
    

    // MARK: - Table view data source
    // MARK: Section Info
        
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return directories.count
    }
    
    // MARK: Cell Info
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let directory: NSDictionary = directories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "directory", for: indexPath)
        
        cell.textLabel?.text = directory["path"] as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        segueDirectory = directories[indexPath.row]
        return indexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let filesTVC: FilesTableViewController = segue.destination as! FilesTableViewController
        filesTVC.directory = segueDirectory
    }
}
