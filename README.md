iOS Sounds and Ringtones
=====================
####Updated
Updated September 2015 with Swift 2.0.

This is a small project demonstrating of how to locate and use system sound files.  I hope this helps you.

##What it Does
- Lists all of the pre-installed system sounds on an iOS device from the `/System/Library/Audio/UISounds` and `/Library/Ringtones` and their sub-folders.
- Allows users to:
 - Click to play the sound listed.
 - Stop a sound from playing (by pressing the X in the corner).
 - Swipe to bookmark sounds for quick reference.
 - Reorder or delete bookmarked sounds.

Unfortunately, this app WILL NOT WORK in the iOS simulator.  You must run it on an iOS device (iPhone, iPad, iPod Touch).

I created this app to solve a particular problem.  Wanting to take advantage of the system sounds already in the phone for a project I had a hard time finding documentation of the files saved in iOS 8 devices.  I'm fairly certain that this will work on iOS 7 devices, but I'm not sure.  I cannot test in the simulator nor do I have any devices still running iOS 7 (sorry).

This is a utility app for devlopers really.  Not for the general public.  I tried to keep the code and formatting as spartan as possible in order to not make things difficult to view and absorb.  It's the bare minimum with a fair amount of comments to help new programmers.

##Screenshots
#####Main Screen
![img_6080](https://cloud.githubusercontent.com/assets/5307697/7855402/5519744c-04ef-11e5-9012-04913a20ec0c.PNG)

#####List Screen (top)
![img_6081](https://cloud.githubusercontent.com/assets/5307697/7855404/5ac8b164-04ef-11e5-853e-26fe444f806c.PNG)

#####List Screen (further down)
![img_6082](https://cloud.githubusercontent.com/assets/5307697/7855407/5fc03174-04ef-11e5-961e-9a02e94871c0.PNG)

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
let fileURL: NSURL = NSURL(fileURLWithPath: "\{directory}\{filename}.{extension}")
do {
  appDelegate.player = try AVAudioPlayer(contentsOfURL: fileURL)
  appDelegate.player.play()
} catch {
  NSLog("\(error)")
}
````
Remember that `appDelegate.player` was defined as `var player: AVAudioPlayer = AVAudioPlayer()` in the `AppDelegate`.  I know that storing things in the appDelegate isn't great. This is just a simple app so I went th simple route.

All of the work in the app comes down to those 4 lines.

I prefer `AVAudioPlayer.play()` to `AudioServicesPlaySystemSound()` because AVAudioPlayer can be stopped (among other features).  Once you start a sound using `AudioServicesPlaySystemSound()` it cannot be stopped.

##References
This was inspired by the [iOSSystemSoundsLibrary by TUNER88](https://github.com/TUNER88/iOSSystemSoundsLibrary).
