import Foundation
import UIKit

class Player {
    // TODO: determine what data a player needs for multipeer connections
    // I am just guessing the type for the peerId, feel free to change it later on
    var peerId: Int
    
    var shortname: String
    
    var image: UIImage
    
    var direction = 0 // north, south, east, west
    
    var score = 0
    
    var selectedAnswer = ""
    
    init(peerId: Int, shortname: String) {
        self.peerId = peerId
        self.shortname = shortname
        
        // TODO: select a random image for the player here
        self.image = UIImage()
    }
    
    init(peerId: Int, shortname: String, image: UIImage) {
        self.peerId = peerId
        self.shortname = shortname
        self.image = image
    }
    
    func awardPoints() {
        self.score += 10
    }
}
