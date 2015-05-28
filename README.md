iOS Sounds and Ringtones
=====================
######Disclaimer
This is a small project demonstrating of how to locate and use system sound files.  I hope this helps you.

##What it Does
- Lists all of the pre-installed system sounds on an iOS device from the `/System/Library/Audio/UISounds` and `/Library/Ringtones` and their sub-folders.
- Allows users to:
 - Plays the sounds when clicked.
 - Stop a sound from playing (by pressing the X in the corner)
 - Swipe to bookmark sounds for quick reference.
 - Reorder or delete bookmarked sounds.

Unfortunately, this app WILL NOT WORK in the iOS simulator.  You must run it on an iOS device (iPhone, iPad, iPod Touch).

I created this app to solve a particular problem.  Wanting to take advantage of the system sounds already in the phone for a project I had a hard time finding documentation of the files saved in iOS 8 devices.  I'm fairly certain that this will work on iOS 7 devices, but I'm not sure.  I cannot test in the simulator nor do I have any devices still running iOS 7 (sorry).

This is a utility app for devlopers really.  Not for the general public.  I tried to keep the code and formatting as spartan as possible in order to not make things difficult to view and absorb.  It's the bare minimum with a fair amount of comments to help new programmers.

##How it works
####Frontend
- The app lists all of the user's bookmarked sounds (if any) as well as provides a link to browse all sounds in the `/System/Library/Audio/UISounds` and `/Library/Ringtones` folders or deeper.
- Click cells to play a sound.
- Swipe from right-to-left to bookmark a sound.
- Swipe bookmarked sounds to remove from bookmarks.
- Click "Edit" button to rearrange bookmarks and/or remove them.

####Backend
- The app starts in the `/System/Library/Audio/UISounds` and `/Library/Ringtones` folders and looks for any sub-directories on that level and puts them all in an array.  
- The app goes to each directory in that array a finds the sound files in each and saves them all in a `(String, [String])` tuple array for programmatic access.
- Bookmarked files are saved to the `NSUserDefaults` on `viewWillDisappear` and loaded on `viewWillAppear`.


##How to make the sounds play
The key piece is really
````
var SSID: SystemSoundID = 0
var fileURL: NSURL = NSURL(fileURLWithPath: "\{directory}\{filename}.{extension}")!
appDelegate.player = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
appDelegate.player.play()
````
Remember that `appDelegate.player` was defined as `var player: AVAudioPlayer = AVAudioPlayer()` in the `AppDelegate`.

All of the work in the app comes down to those 4 lines.

I prefer `AVAudioPlayer.play()` to `AudioServicesPlaySystemSound()` because AVAudioPlayer can be stopped (among other features).  Once you start a sound using `AudioServicesPlaySystemSound()` it cannot be stopped.

##References
This was inspired by the [iOSSystemSoundsLibrary by TUNER88](https://github.com/TUNER88/iOSSystemSoundsLibrary).
