iOS Sounds and Ringtones
=====================

### List of changes:
* Updated to iPhone X interface
* Adapted to Swift 4
* Uses iOS 11 large titles
* App now supports landscape mode and iPad

This is a small project demonstrating of how to locate and use system sound files.  I hope this helps you.

## What it Does
- Lists all of the pre-installed system sounds on an iOS device from the `/System/Library/Audio/UISounds` and `/Library/Ringtones` and their sub-folders.
- Allows users to:
 - Click to play the sound listed.
 - Swipe from left to right to bookmark sounds for quick reference.
 - Reorder or delete bookmarked sounds.

Unfortunately, this app WILL NOT WORK in the iOS simulator.  You must run it on an iOS device (iPhone, iPad, iPod Touch).

I created this app to solve a particular problem.  Wanting to take advantage of the system sounds already in the phone for a project I had a hard time finding documentation of the files saved in iOS 8 devices.  I'm fairly certain that this will work on iOS 7 devices, but I'm not sure.  I cannot test in the simulator nor do I have any devices still running iOS 7 (sorry).

This is a utility app for devlopers really.  Not for the general public.  I tried to keep the code and formatting as spartan as possible in order to not make things difficult to view and absorb.  It's the bare minimum with a fair amount of comments to help new programmers.

## Screenshots
##### Main Screen
![img_7065](https://cloud.githubusercontent.com/assets/5307697/14158849/85cdfeb6-f6a0-11e5-8e79-63331f69ba0c.PNG)

##### List Screen
![img_7066](https://cloud.githubusercontent.com/assets/5307697/14158854/8825acae-f6a0-11e5-97df-70d9d38ccd54.PNG    )

## How it works
#### Frontend
- The app lists all of the user's bookmarked sounds (if any) as well as provides a link to browse all sounds in the `/System/Library/Audio/UISounds` and `/Library/Ringtones` folders or deeper.
- Click cells to play a sound.
- Swipe from right-to-left to bookmark a sound.
- Swipe bookmarked sounds to remove from bookmarks.
- Click "Edit" button to rearrange bookmarks and/or remove them.

#### Backend
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
All of the work in the app comes down to those few lines.

##References
This was inspired by the [iOSSystemSoundsLibrary by TUNER88](https://github.com/TUNER88/iOSSystemSoundsLibrary).
