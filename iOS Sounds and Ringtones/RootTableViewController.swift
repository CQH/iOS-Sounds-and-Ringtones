import UIKit
import AVFoundation

class RootTableViewController: UITableViewController {
    // MARK: - Class Variables
    
    ///Model singleton
    let model = Model.sharedInstance()

    ///Enumerator for different sections on the root page.
    enum SectionType: Int {
        ///ENUM for all files section.
        case AllFiles = 0
        
        ///ENUM for Bookmarks section.
        case Bookmarks
    }

    // MARK: - ViewController Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        getBookmarks()
    }
    
    override func viewWillDisappear(animated: Bool) {
        setBookmarks()
    }
    
    ///Sets the bookmarked files into the user defaults.
    func setBookmarks() {
        model.userDefaults.setObject(model.bookmarkedFiles, forKey: "bookmarkedSoundFiles")
        model.userDefaults.synchronize()
    }
    
    ///Gets the user's bookmarked files and updates the table section.
    func getBookmarks() {
        model.userDefaults.synchronize()
        if let bookmarks: [String] = model.userDefaults.objectForKey("bookmarkedSoundFiles") as? [String] {
            model.bookmarkedFiles = bookmarks
        }
        tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)
    }
    
    // MARK: - Tables
    // MARK: Sections
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SectionType.Bookmarks.rawValue:
            return model.bookmarkedFiles.count
        case SectionType.AllFiles.rawValue:
            return 1
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case SectionType.Bookmarks.rawValue:
            if model.bookmarkedFiles.count == 0 {
                return "No bookmarked sound files"
            } else {
                return "\(model.bookmarkedFiles.count) bookmarked sound file(s)"
            }
        case SectionType.AllFiles.rawValue:
            return "All Sound Files"
        default:
            return ""
        }
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
            let filePath: String = model.bookmarkedFiles[indexPath.row]
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
            let filePath: String = model.bookmarkedFiles[indexPath.row]
            let fileURL: NSURL = NSURL(fileURLWithPath: "\(filePath)")
            
            do {
                model.audioPlayer = try AVAudioPlayer(contentsOfURL: fileURL)
                model.audioPlayer.play()
            } catch {
                debugPrint("\(error)")
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
            model.bookmarkedFiles.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            setBookmarks()
            getBookmarks()
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let filePath: String = model.bookmarkedFiles[fromIndexPath.row]
        if (fromIndexPath.section == SectionType.Bookmarks.rawValue) && (toIndexPath.section == SectionType.Bookmarks.rawValue) {
            //If I'm moving from and to the same section (bookmarks), then proceed.
            if fromIndexPath.row > toIndexPath.row { //Moving items up in the list
                model.bookmarkedFiles.insert(filePath, atIndex: toIndexPath.row)
                model.bookmarkedFiles.removeAtIndex(fromIndexPath.row + 1)
            } else { //Moving items down in the list.
                model.bookmarkedFiles.insert(filePath, atIndex: toIndexPath.row + 1)
                model.bookmarkedFiles.removeAtIndex(fromIndexPath.row)
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
