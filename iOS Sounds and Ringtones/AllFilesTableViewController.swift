import UIKit
import AVFoundation

class AllFilesTableViewController: UITableViewController {
    // MARK: - Class Variables
    
    ///Model singleton
    let model = Model.sharedInstance()

    ///The directories where sound files are located.
    let rootSoundDirectories: [String] = ["/Library/Ringtones", "/System/Library/Audio/UISounds"]
    
    ///Array to hold directories when we find them.
    var directories: [String] = []
    
    ///Tuple to hold directories and an array of file names within.
    var soundFiles: [(directory: String, files: [String])] = []
    
    // MARK: - View Controller Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        for directory in rootSoundDirectories {
            directories.append(directory)
            
            let newSoundFile: (directory: String, files: [String]) = (directory, [])
            soundFiles.append(newSoundFile)
        }
        getDirectories()
        loadSoundFiles()
    }
    
    override func viewWillAppear(animated: Bool) {
        model.userDefaults.synchronize()
        if let bookmarks: [String] = model.userDefaults.objectForKey("bookmarkedSoundFiles") as? [String] {
            model.bookmarkedFiles = bookmarks
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        model.userDefaults.setObject(model.bookmarkedFiles, forKey: "bookmarkedSoundFiles")
        model.userDefaults.synchronize()
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
        let fileManager: NSFileManager = NSFileManager()
        for directory in rootSoundDirectories {
            let directoryURL: NSURL = NSURL(fileURLWithPath: "\(directory)", isDirectory: true)
            
            do {
                if let URLs: [NSURL] = try fileManager.contentsOfDirectoryAtURL(directoryURL, includingPropertiesForKeys: [NSURLIsDirectoryKey], options: NSDirectoryEnumerationOptions()) {
                    var urlIsaDirectory: ObjCBool = ObjCBool(false)
                    for url in URLs {
                        if fileManager.fileExistsAtPath(url.path!, isDirectory: &urlIsaDirectory) {
                            if urlIsaDirectory {
                                let directory: String = "\(url.relativePath!)"
                                let files: [String] = []
                                let newSoundFile: (directory: String, files: [String]) = (directory, files)
                                directories.append("\(directory)")
                                soundFiles.append(newSoundFile)
                            }
                        }
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
    func loadSoundFiles() {
        for i in 0...directories.count-1 {
            let fileManager: NSFileManager = NSFileManager()
            let directoryURL: NSURL = NSURL(fileURLWithPath: directories[i], isDirectory: true)
            
            do {
                if let URLs: [NSURL] = try fileManager.contentsOfDirectoryAtURL(directoryURL, includingPropertiesForKeys: [NSURLIsDirectoryKey], options: NSDirectoryEnumerationOptions()) {
                    var urlIsaDirectory: ObjCBool = ObjCBool(false)
                    for url in URLs {
                        if fileManager.fileExistsAtPath(url.path!, isDirectory: &urlIsaDirectory) {
                            if !urlIsaDirectory {
                                soundFiles[i].files.append("\(url.lastPathComponent!)")
                            }
                        }
                    }
                }
            } catch {
                debugPrint("\(error)")
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
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
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
        let fileURL: NSURL = NSURL(fileURLWithPath: "\(directory)/\(fileName)")
        do {
            model.audioPlayer = try AVAudioPlayer(contentsOfURL: fileURL)
            model.audioPlayer.play()
        } catch {
            debugPrint("\(error)")
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
        }
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let bookmarkAction: UITableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Bookmark" , handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
            let directory: String = self.soundFiles[indexPath.section].directory
            let fileName: String = self.soundFiles[indexPath.section].files[indexPath.row]
            let filePath: String = "\(directory)/\(fileName)"
            self.model.bookmarkedFiles.append(filePath)
            tableView.setEditing(false, animated: true)
        })
        return [bookmarkAction]
    }
}
