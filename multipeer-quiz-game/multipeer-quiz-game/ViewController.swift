import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate {
    var singlePlayerGame: SinglePlayerGame?
    var multiplayerGame: MultiPlayerGame?

    var session: MCSession!
    var peerID: MCPeerID!
    var browser: MCBrowserViewController!
    var assistant: MCAdvertiserAssistant!

    @IBOutlet weak var segmentedControlForPlayer: UISegmentedControl!
    @IBOutlet weak var startGameButton: UIButton!

    var multiplayer = false

    @IBAction func segmentedControlUpdated(_ sender: Any) {
        switch self.segmentedControlForPlayer.selectedSegmentIndex {
        case 0:
            self.multiplayer = false
        case 1:
            self.multiplayer = true
        default:
            break;
        }
    }

    @IBAction func buttonPress(_ sender: Any) {
        if (!multiplayer){
            performSegue(withIdentifier: "toQuiz", sender: self)
        } else {
            if (self.multiplayerGame?.canStartGame())! {
                do{
                    let data =  NSKeyedArchiver.archivedData(withRootObject: "START")
                    try session.send(data, toPeers: session.connectedPeers, with: .unreliable)
                }
                catch let err {
                    print("Error in sending data \(err)")
                }

                performSegue(withIdentifier: "toQuiz", sender: self)
            } else {
                let alert = UIAlertController(title: "Error", message: "Not enough People", preferredStyle: .alert)

                let myAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

                alert.addAction(myAction)

                present(alert, animated: true, completion: nil)
            }
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: peerID)
        self.browser = MCBrowserViewController(serviceType: "Connect", session: session)
        self.assistant = MCAdvertiserAssistant(serviceType: "Connect", discoveryInfo: nil, session: session)

        self.assistant.start()
        session.delegate = self
        browser.delegate = self

        self.singlePlayerGame = SinglePlayerGame(currentPlayer: Player(peerId: self.peerID))
        self.multiplayerGame = MultiPlayerGame(currentPlayer: Player(peerId: self.peerID), session: self.session)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        // this needs to be run on the main thread
        DispatchQueue.main.async(execute: {
            if let receivedString = NSKeyedUnarchiver.unarchiveObject(with: data) as? String {
                switch receivedString {
                    case "START":
                        self.multiplayer = true
                        self.performSegue(withIdentifier: "toQuiz", sender: self)
                    default:
                        print("I can't handle all this input! Got:", receivedString)
                        break;
                }
            }
        })
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {

    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {

    }

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            let player = Player(peerId: peerID)
            self.multiplayerGame?.players.append(player)

        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")

        case MCSessionState.notConnected:
            // remove disconnected players
            let playerIndex = (self.multiplayerGame?.getPlayerIndex(by: peerID))!
            if playerIndex > 0 {
                self.multiplayerGame?.players.remove(at: playerIndex)
            }
        }
    }

    //**********************************************************
    //**********************************************************

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let quizViewController = segue.destination as! QuizController
        quizViewController.game = self.multiplayer ? self.multiplayerGame : self.singlePlayerGame

        quizViewController.session = self.session
        quizViewController.browser = self.browser
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


