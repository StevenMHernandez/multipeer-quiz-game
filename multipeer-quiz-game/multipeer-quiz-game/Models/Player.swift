import Foundation
import UIKit
import MultipeerConnectivity

class Player {
    var peerId: MCPeerID
    
    var image: UIImage
    
    var direction = 0 // north, south, east, west
    
    var score = 0
    
    var selectedAnswer = ""
    
    func randPicture() -> UIImage{
        let randNum = arc4random_uniform(4)+1
        let icon = UIImage(named: "icon\(randNum)")
        return icon!
    }
    
    init(peerId: MCPeerID) {
        self.peerId = peerId
        self.image = UIImage()
        self.image = randPicture()
    }
    
    init(peerId: MCPeerID, image: UIImage) {
        self.peerId = peerId
        self.image = image
    }
    
    func awardPoints() {
        self.score += 10
    }
}
