iOS Sounds & Ringtones
=====================

### List of changes:
* Update to iPhone X interface
* Update to Swift 4
* Use iOS 11-like large headers
* Support landscape mode and iPad

This is a small project demonstrating how to locate and use system sound files. Hope it helps you.

## What it Does
- List all pre-installed system sounds on an iOS device from `/System/Library/Audio/UISounds`, `/Library/Ringtones`, and their sub-folders.
- Allow to:
 - Tap to play any listed sound.
 - Swipe left to bookmark sounds for quick reference.
 - Reorder or delete bookmarks.

*This app WILL NOT WORK in the simulator. You must run it on a physical device (supports the iPhone, iPad, and iPod Touch).*

I created this app to take advantage of the system sounds so as to use them for a project.

Note: this should work as far back as iOS 7 (not tested).

This app is aimed at developers, inasmuch as the general public. I kept the code and formatting as spartan as possible in order not to make things difficult to understand. It's the bare minimum. With a fair amount of comments to help new programmers.

## Screenshots
##### Main Screen
![img_7065](https://cloud.githubusercontent.com/assets/5307697/14158849/85cdfeb6-f6a0-11e5-8e79-63331f69ba0c.PNG)

##### List Screen
![img_7066](https://cloud.githubusercontent.com/assets/5307697/14158854/8825acae-f6a0-11e5-97df-70d9d38ccd54.PNG    )

## How it works
#### Front-end
- The app lists all of the user's bookmarked sounds (if any) as well as providing navigation to browse `/System/Library/Audio/UISounds`, `/Library/Ringtones`, and their sub-folders.
- Tap on a cell to play its sound.
- Swipe left on a cell to bookmark it.
- Swipe a bookmark to remove it from bookmarks.
- Tap on "Edit" to rearrange bookmarks or remove them.

#### Back-end
- The app starts in the `/System/Library/Audio/UISounds` and `/Library/Ringtones` folders and looks for any sub-directories on that level and puts them all in an array.  
- The app goes to each directory in that array a finds the sound files in each and saves them all in a `[NSDictionary]` array of dictionaries for programmatic access.
- Bookmarked files are saved to the `NSUserDefaults` on `viewWillDisappear` and loaded on `viewWillAppear`.


## How to make the sounds play
The key piece is really
````
let fileURL: NSURL = NSURL(fileURLWithPath: "\{directory}\{filename}.{extension}")
do {
    appController.audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
    appController.audioPlayer.play()
} catch {
    debugPrint("\(error)")
}
````
How the app works really comes down to these few lines.

## References
This was inspired by the [iOSSystemSoundsLibrary by TUNER88](https://github.com/TUNER88/iOSSystemSoundsLibrary).
