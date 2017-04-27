import Foundation
import UIKit
import MultipeerConnectivity

class Player {
    var peerId: MCPeerID
    
    var image: UIImage
    
    var direction = 0 // north, south, east, west
    
    var score = 0
    
    var selectedAnswer = ""
    
    init(peerId: MCPeerID) {
        self.peerId = peerId
        
        // TODO: select a random image for the player here
        self.image = UIImage()
    }
    
    init(peerId: MCPeerID, image: UIImage) {
        self.peerId = peerId
        self.image = image
    }
    
    func awardPoints() {
        self.score += 10
    }
}
