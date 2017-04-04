import UIKit
import AVFoundation

class RootTableViewController: UITableViewController {
    // MARK: - Class Variables
    
    ///App Controller singleton
    let appController = AppController.sharedInstance()

    ///Enumerator for different sections on the root page.
    enum SectionType: Int {
        ///ENUM for all files section.
        case allFiles = 0
        
        ///ENUM for Bookmarks section.
        case bookmarks
    }

    // MARK: - ViewController Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem

        do { //Enable the device to play even when the mute switch is on. This may not be necessary for all devices. Thanks to Philip van Allen for this suggestion.
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            debugPrint("\(error)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getBookmarks()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        setBookmarks()
    }
    
    ///Sets the bookmarked files into the user defaults.
    func setBookmarks() {
        appController.userDefaults.set(appController.bookmarkedFiles, forKey: "bookmarkedSoundFiles")
        appController.userDefaults.synchronize()
    }
    
    ///Gets the user's bookmarked files and updates the table section.
    func getBookmarks() {
        appController.userDefaults.synchronize()
        if let bookmarks: [String] = appController.userDefaults.object(forKey: "bookmarkedSoundFiles") as? [String] {
            appController.bookmarkedFiles = bookmarks
        }
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
    }
    
    // MARK: - Tables
    // MARK: Sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SectionType.bookmarks.rawValue:
            return appController.bookmarkedFiles.count
        case SectionType.allFiles.rawValue:
            return 1
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case SectionType.bookmarks.rawValue:
            if appController.bookmarkedFiles.count == 0 {
                return "No bookmarked sound files"
            } else {
                return "\(appController.bookmarkedFiles.count) bookmarked sound file(s)"
            }
        case SectionType.allFiles.rawValue:
            return "All Sound Files"
        default:
            return ""
        }
    }
    
    // MARK: Cells

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SectionType.bookmarks.rawValue {
            let filePath: String = appController.bookmarkedFiles[indexPath.row]
            let fileURL: URL = URL(fileURLWithPath: filePath)
            let fileName: String = fileURL.lastPathComponent
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "sound", for: indexPath) as! SoundTableViewCell
            
            cell.fileNameLabel.text = fileName
            cell.filePathLabel.text = filePath
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "all sounds", for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SectionType.bookmarks.rawValue {
            let filePath: String = appController.bookmarkedFiles[indexPath.row]
            let fileURL: URL = URL(fileURLWithPath: "\(filePath)")
            
            do {
                appController.audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
                appController.audioPlayer.play()
            } catch {
                debugPrint("\(error)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == SectionType.bookmarks.rawValue {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            appController.bookmarkedFiles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            setBookmarks()
            getBookmarks()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        let filePath: String = appController.bookmarkedFiles[fromIndexPath.row]
        if (fromIndexPath.section == SectionType.bookmarks.rawValue) && (toIndexPath.section == SectionType.bookmarks.rawValue) {
            //If I'm moving from and to the same section (bookmarks), then proceed.
            if fromIndexPath.row > toIndexPath.row { //Moving items up in the list
                appController.bookmarkedFiles.insert(filePath, at: toIndexPath.row)
                appController.bookmarkedFiles.remove(at: fromIndexPath.row + 1)
            } else { //Moving items down in the list.
                appController.bookmarkedFiles.insert(filePath, at: toIndexPath.row + 1)
                appController.bookmarkedFiles.remove(at: fromIndexPath.row)
            }
        }
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == SectionType.bookmarks.rawValue {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.section == SectionType.allFiles.rawValue {
            return IndexPath(row: 0, section: SectionType.bookmarks.rawValue)
        }
        return proposedDestinationIndexPath
    }
}
