import UIKit
import AVFoundation

class Model: NSObject {
    ///Audio player responsible for playing sound files.
    var audioPlayer: AVAudioPlayer = AVAudioPlayer()
    
    ///User's bookmarked sound files.
    var bookmarkedFiles: [String] = []
    
    ///User defaults
    var userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    class func sharedInstance() -> Model {
        return modelSingletonGlobal
    }
}

///Model singleton so that we can refer to this from throughout the app.
let modelSingletonGlobal = Model()