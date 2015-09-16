//
//  RootTableViewController.swift
//  System Sounds Library
//
//  Created by Carleton Hall on 5/25/15.
//  Copyright (c) 2015 Carleton Hall. All rights reserved.
//

import UIKit
import AVFoundation

class RootTableViewController: UITableViewController {
    // MARK: - Class Variables
    var userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    ///Enumerator for different sections on the root page.
    enum SectionType: Int {
        
        ///ENUM for all files section.
        case AllFiles = 0
        
        ///ENUM for Bookmarks section.
        case Bookmarks
    }

    // MARK: Outlets
    @IBOutlet var editButton: UIBarButtonItem!
    @IBAction func editButtonAction(sender: AnyObject) {
        if tableView.editing {
            tableView.setEditing(false, animated: true)
            editButton.title = "Edit"
        } else {
            tableView.setEditing(true, animated: true)
            editButton.title = "Done"
        }
    }
    
    ///If the player is playing, stops it.
    @IBAction func stopButton(sender: AnyObject) {
        if appDelegate.player.playing {
            appDelegate.player.stop()
        }
    }
    
    // MARK: - ViewController Setup
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        userDefaults.synchronize()
        if let bookmarks: [String] = userDefaults.objectForKey("bookmarkedSoundFiles") as? [String] {
            appDelegate.bookmarkedFiles = bookmarks
            tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        userDefaults.setObject(appDelegate.bookmarkedFiles, forKey: "bookmarkedSoundFiles")
        userDefaults.synchronize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Tables
    // MARK: Sections
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue: Int = 0
        switch section {
        case SectionType.Bookmarks.rawValue:
            returnValue = appDelegate.bookmarkedFiles.count
        case SectionType.AllFiles.rawValue:
            returnValue = 1
        default: break
        }
        return returnValue
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var returnValue: String = ""
        switch section {
        case SectionType.Bookmarks.rawValue:
            returnValue = "Bookmarked Sound Files"
        case SectionType.AllFiles.rawValue:
            returnValue = "All Sound Files"
        default: break
        }
        return returnValue
    }
    
    // MARK: Cells

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        switch indexPath.section {
        case SectionType.Bookmarks.rawValue:
            let filePath: String = appDelegate.bookmarkedFiles[indexPath.row]
            let fileURL: NSURL = NSURL(fileURLWithPath: filePath)
            let fileName: String = fileURL.lastPathComponent! //filePath.lastPathComponent
            cell = tableView.dequeueReusableCellWithIdentifier("bookmark", forIndexPath: indexPath) 
            let fileNameLabel: UILabel = cell.viewWithTag(1) as! UILabel
            let filePathLabel: UILabel = cell.viewWithTag(2) as! UILabel
            
            fileNameLabel.text = fileName
            filePathLabel.text = filePath
        case SectionType.AllFiles.rawValue:
            cell = tableView.dequeueReusableCellWithIdentifier("all sounds", forIndexPath: indexPath) 
        default: break
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == SectionType.Bookmarks.rawValue {
            let filePath: String = appDelegate.bookmarkedFiles[indexPath.row]
            let fileURL: NSURL = NSURL(fileURLWithPath: "\(filePath)")
            
            do {
                appDelegate.player = try AVAudioPlayer(contentsOfURL: fileURL)
                appDelegate.player.play()
            } catch {
                NSLog("\(error)")
            }
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == SectionType.Bookmarks.rawValue {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            appDelegate.bookmarkedFiles.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let filePath: String = appDelegate.bookmarkedFiles[fromIndexPath.row]
        if (fromIndexPath.section == SectionType.Bookmarks.rawValue) && (toIndexPath.section == SectionType.Bookmarks.rawValue) {
            //If I'm moving from and to the same section (bookmarks), then proceed.
            if fromIndexPath.row > toIndexPath.row { //Moving items up in the list
                appDelegate.bookmarkedFiles.insert(filePath, atIndex: toIndexPath.row)
                appDelegate.bookmarkedFiles.removeAtIndex(fromIndexPath.row + 1)
            } else { //Moving items down in the list.
                appDelegate.bookmarkedFiles.insert(filePath, atIndex: toIndexPath.row + 1)
                appDelegate.bookmarkedFiles.removeAtIndex(fromIndexPath.row)
            }
        }
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == SectionType.Bookmarks.rawValue {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        if proposedDestinationIndexPath.section == SectionType.AllFiles.rawValue {
            return NSIndexPath(forRow: 0, inSection: SectionType.Bookmarks.rawValue)
        }
        return proposedDestinationIndexPath
    }
}
