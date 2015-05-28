//
//  AllFilesTableViewController.swift
//  System Sounds Library
//
//  Created by Carleton Hall on 5/21/15.
//  Copyright (c) 2015 Carleton Hall. All rights reserved.
//

import UIKit
import AVFoundation

class AllFilesTableViewController: UITableViewController {
    // MARK: - Class Variables
    ///NSUserDefaults to hold the users favorite bookmarked files.
    var userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
   
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    ///The directories where sound files are located.
    var rootSoundDirectories: [String] = []
    
    ///Array to hold directories when we find them.
    var directories: [String] = []
    
    ///Tuple to hold directories and an array of file names within.
    var soundFiles: [(directory: String, files: [String])] = []
    
    // MARK: - Outlets
    ///If the player is playing, stops it.
    @IBAction func stopButton(sender: AnyObject) {
        if appDelegate.player.playing {
            appDelegate.player.stop()
        }
    }
    // MARK: - View Controller Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        rootSoundDirectories = ["/Library/Ringtones", "/System/Library/Audio/UISounds"]
        for directory in rootSoundDirectories {
            directories.append(directory)
            
            let newSoundFile: (directory: String, files: [String]) = (directory, [])
            soundFiles.append(newSoundFile)
        }
        getDirectories()
        loadSoundFiles()
    }
    
    override func viewWillAppear(animated: Bool) {
        userDefaults.synchronize()
        if let bookmarks: [String] = userDefaults.objectForKey("bookmarkedSoundFiles") as? [String] {
            appDelegate.bookmarkedFiles = bookmarks
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        userDefaults.setObject(appDelegate.bookmarkedFiles, forKey: "bookmarkedSoundFiles")
        userDefaults.synchronize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: - Class Functions
    /**
    Starting with the "/Library/Ringtones" & "/System/Library/Audio/UISounds" directories, it looks for other sub-directories just one level lower and saves their relative path in directories array.
    
    - URLs: All of the contents of the directory (files and sub-directories).
    */
    func getDirectories() {
        var err: NSError!
        var fileManager: NSFileManager = NSFileManager()
        for directory in rootSoundDirectories {
            var directoryURL: NSURL = NSURL(fileURLWithPath: "\(directory)", isDirectory: true)!
            if let URLs: [NSURL] = fileManager.contentsOfDirectoryAtURL(directoryURL, includingPropertiesForKeys: [NSURLIsDirectoryKey], options: NSDirectoryEnumerationOptions.allZeros, error: nil) as? [NSURL] {
                for url in URLs {
                    var isDirectory: AnyObject?
                    if url.getResourceValue(&isDirectory, forKey: NSURLIsDirectoryKey, error: nil){
                        if isDirectory! as! NSObject == 1 {
                            directories.append("\(url.relativePath!)")
                            soundFiles.append(directory: "\(url.relativePath!)", files: [])
                        }
                    }
                    isDirectory = nil
                }
            }
        }
    }
    
    /**
    For each directory, it looks at each item (file or directory) and only appends the sound files to the soundfiles[i]files array.
    
    - URLs: All of the contents of the directory (files and sub-directories).
    */
    func loadSoundFiles() {
        for i in 0...directories.count-1 {
            var err: NSError!
            var fileManager: NSFileManager = NSFileManager()
            var directoryURL: NSURL = NSURL(fileURLWithPath: directories[i], isDirectory: true)!
            if let URLs: [NSURL] = fileManager.contentsOfDirectoryAtURL(directoryURL, includingPropertiesForKeys: [NSURLIsDirectoryKey], options: NSDirectoryEnumerationOptions.allZeros, error: nil) as? [NSURL] {
                for url in URLs {
                    var isDirectory: AnyObject?
                    if url.getResourceValue(&isDirectory, forKey: NSURLIsDirectoryKey, error: nil){
                        if isDirectory! as! NSObject == 0 {
                            soundFiles[i].files.append("\(url.lastPathComponent!)")
                        }
                    }
                    isDirectory = nil
                }
            }
        }
    }
    
    
    // MARK: - Table view data source
    // MARK: Section Info
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return directories.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundFiles[section].files.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return directories[section]
    }
    
    // MARK: Cell Info
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let directory: String = soundFiles[indexPath.section].directory
        let fileName: String = soundFiles[indexPath.section].files[indexPath.row]
        let filePath: String = "\(directory)/\(fileName)"
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        let fileNameLabel: UILabel = cell.viewWithTag(1) as! UILabel
        let filePathLabel: UILabel = cell.viewWithTag(2) as! UILabel
        
        fileNameLabel.text = fileName
        filePathLabel.text = filePath

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Play the sound
        let directory: String = soundFiles[indexPath.section].directory
        let fileName: String = soundFiles[indexPath.section].files[indexPath.row]
        var SSID: SystemSoundID = 0
        var fileURL: NSURL = NSURL(fileURLWithPath: "\(directory)/\(fileName)")!
        
        appDelegate.player = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
        appDelegate.player.play()
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete { // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert { // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var bookmarkAction: UITableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Bookmark" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            let directory: String = self.soundFiles[indexPath.section].directory
            let fileName: String = self.soundFiles[indexPath.section].files[indexPath.row]
            let filePath: String = "\(directory)/\(fileName)"
            self.appDelegate.bookmarkedFiles.append(filePath)
            tableView.setEditing(false, animated: true)
        })
        return [bookmarkAction]
    }
}
