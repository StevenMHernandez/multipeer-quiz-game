import UIKit
import MultipeerConnectivity
class ViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate {
    var session: MCSession!
    var peerID: MCPeerID!
    var browser: MCBrowserViewController!
    var assistant: MCAdvertiserAssistant!
    
    @IBOutlet weak var segmentedControlForPlayer: UISegmentedControl!
    @IBOutlet weak var startGameButton: UIButton!
    
    var numPlayers = Int(0)
    
    @IBAction func segmentedControlUpdated(_ sender: Any) {
        switch self.segmentedControlForPlayer.selectedSegmentIndex
        {
        case 0:
            numPlayers = 0
            
        case 1:
            numPlayers = 1
        default:
            break;
        }
    }
    
    @IBAction func buttonPress(_ sender: Any) {
        if(numPlayers == 0){
            performSegue(withIdentifier: "toQuiz", sender: self)
        }
        else{
            let alert = UIAlertController(title: "Error", message: "Not enough People", preferredStyle: .alert)
            
            let myAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(myAction)
            
            present(alert, animated: true, completion: nil)

        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: peerID)
        self.browser = MCBrowserViewController(serviceType: "Connect", session: session)
        self.assistant = MCAdvertiserAssistant(serviceType: "Connect", discoveryInfo: nil, session: session)
        session.delegate = self
        browser.delegate = self

       
    }
    
    @IBAction func connectToDevice(_ sender: Any) {
        present(browser, animated: true, completion: nil)
    }
    
    
    
    //**********************************************************
    // required functions for MCBrowserViewControllerDelegate
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        // Called when the browser view controller is dismissed
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        // Called when the browser view controller is cancelled
        dismiss(animated: true, completion: nil)
    }
    //**********************************************************
    // required functions for MCSessionDelegate
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        // Called when a connected peer changes state (for example, goes offline)
        
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
        
    }
    //**********************************************************
    //**********************************************************

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let quizViewController = segue.destination as! QuizController
            quizViewController.numPlayers = self.numPlayers
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


