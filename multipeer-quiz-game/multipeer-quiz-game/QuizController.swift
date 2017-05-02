import UIKit
import MultipeerConnectivity
import CoreMotion
import GameplayKit
import Firebase

class QuizController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate {
    /*
     * This could either be a multiplayer or singleplayer quiz.
     * but because we don't care which it is in this controller
     * we just consider it a generic game.
     * When we call methods on this game (such as game.nextQuestion())
     * we don't worry about how we handle single vs multiplayer games
     * we let this object handle that logic itself
     */
    var game: GenericGame?
    
    var session: MCSession!
    var browser: MCBrowserViewController!
    
    var selectedOption: String?
    var jsonQuiz = JsonQuizLoader()
    var players: [Player]!
    var question: Question! = nil
    var numPlayers: Int!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var restartQuizButton: UIButton!
    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var answerALabel: UILabel!
    @IBOutlet weak var answerBLabel: UILabel!
    @IBOutlet weak var answerCLabel: UILabel!
    @IBOutlet weak var answerDLabel: UILabel!
    @IBOutlet weak var answerAView: UIView!
    @IBOutlet weak var answerBView: UIView!
    @IBOutlet weak var answerCView: UIView!
    @IBOutlet weak var answerDView: UIView!
    @IBOutlet weak var player1Score: UILabel!
    @IBOutlet weak var player2Score: UILabel!
    @IBOutlet weak var player3Score: UILabel!
    @IBOutlet weak var player4Score: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var player1Icon: UIImageView!
    @IBOutlet weak var player2Icon: UIImageView!
    @IBOutlet weak var player3Icon: UIImageView!
    @IBOutlet weak var player4Icon: UIImageView!
    var answerABool = false
    var answerBBool = false
    var answerCBool = false
    var answerDBool = false
    
    var motionManager: CMMotionManager!
    
    var timerRunning = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first{
            if touch.view == self.answerALabel {
                answerAView.backgroundColor = UIColor.yellow
                answerBView.backgroundColor = UIColor.lightGray
                answerCView.backgroundColor = UIColor.lightGray
                answerDView.backgroundColor = UIColor.lightGray
                answerABool = true; answerBBool = false
                answerCBool = false; answerDBool = false
                selectedOption = "A"
            } else if touch.view == self.answerBLabel {
                answerAView.backgroundColor = UIColor.lightGray
                answerBView.backgroundColor = UIColor.yellow
                answerCView.backgroundColor = UIColor.lightGray
                answerDView.backgroundColor = UIColor.lightGray
                answerABool = false; answerBBool = true
                answerCBool = false;  answerDBool = false
                selectedOption = "B"
            } else if touch.view == self.answerCLabel {
                answerAView.backgroundColor = UIColor.lightGray
                answerBView.backgroundColor = UIColor.lightGray
                answerCView.backgroundColor = UIColor.yellow
                answerDView.backgroundColor = UIColor.lightGray
                answerABool = false; answerBBool = false
                answerCBool = true; answerDBool = false
                selectedOption = "C"
            } else if touch.view == self.answerDLabel {
                answerAView.backgroundColor = UIColor.lightGray
                answerBView.backgroundColor = UIColor.lightGray
                answerCView.backgroundColor = UIColor.lightGray
                answerDView.backgroundColor = UIColor.yellow
                answerABool = false; answerBBool = false
                answerCBool = false; answerDBool = true
                selectedOption = "D"
            } else{
                print("touch Registered")
                return
            }
            
        }
    }
    
    func selectAnswer(answer: String) {
        if answer == "A" {
            answerAView.backgroundColor = UIColor.yellow
            answerBView.backgroundColor = UIColor.lightGray
            answerCView.backgroundColor = UIColor.lightGray
            answerDView.backgroundColor = UIColor.lightGray
            answerABool = true; answerBBool = false
            answerCBool = false; answerDBool = false
            selectedOption = "A"
        } else if answer == "B" {
            answerAView.backgroundColor = UIColor.lightGray
            answerBView.backgroundColor = UIColor.yellow
            answerCView.backgroundColor = UIColor.lightGray
            answerDView.backgroundColor = UIColor.lightGray
            answerABool = false; answerBBool = true
            answerCBool = false;  answerDBool = false
            selectedOption = "B"
        } else if answer == "C" {
            answerAView.backgroundColor = UIColor.lightGray
            answerBView.backgroundColor = UIColor.lightGray
            answerCView.backgroundColor = UIColor.yellow
            answerDView.backgroundColor = UIColor.lightGray
            answerABool = false; answerBBool = false
            answerCBool = true; answerDBool = false
            selectedOption = "C"
        } else if answer == "D" {
            answerAView.backgroundColor = UIColor.lightGray
            answerBView.backgroundColor = UIColor.lightGray
            answerCView.backgroundColor = UIColor.lightGray
            answerDView.backgroundColor = UIColor.yellow
            answerABool = false; answerBBool = false
            answerCBool = false; answerDBool = true
            selectedOption = "D"
        } else{
            print("unknown answer value:", answer)
            return
        }
    }
    
    //    override func loadView() {
    //        game?.loadNewQuiz()
    //    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "The Game."
        
        FIRApp.configure()
        
        session.delegate = self
        browser.delegate = self
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(QuizController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        player1Icon.image = self.game?.players[0].image
        if((self.game?.players.count)! > 1){
        player2Icon.image = self.game?.players[1].image
//        player3Icon.image = self.game?.players[2].image
//        player4Icon.image = self.game?.players[3].image
        }
        //        monitorDeviceOrientation()
        self.motionManager = CMMotionManager()
        
        game?.loadNewQuiz()
        
        // Load first Question:
        self.nextQuestion()
    }
    
    
    //    func monitorDeviceOrientation(){
    //
    //        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    //
    //        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    //    }
    
    //    func orientationChanged(_ notification: Notification){
    //        print(UIDevice.current.orientation.rawValue)
    ////        lbl.text = String(UIDevice.current.orientation.rawValue)
    //    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        session.delegate = self
        browser.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.motionManager.deviceMotionUpdateInterval = 1.0/60.0
        self.motionManager.startDeviceMotionUpdates(using: .xArbitraryCorrectedZVertical)
        
                Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(updateDeviceMotion), userInfo: nil, repeats: true)
        
        //        let cmmam = CMMotionActivityManager()
        //        cmmam.startActivityUpdates(to: .main, withHandler: { (data) in
        //            if let inVehicle = data?.automotive{
        //
        //                if (inVehicle) {
        //                    print(" I am inside a vehicle")
        //                }
        //            }
        //        })
    }
    
    
    
        func updateDeviceMotion(){
    
            if let data = self.motionManager.deviceMotion {
    
                // orientation of body relat    ive to a reference frame
                let attitude = data.attitude
    
                let userAcceleration = data.userAcceleration
    
                let gravity = data.gravity
                let rotation = data.rotationRate
                
                if userAcceleration.z > 2.5 || attitude.yaw > 1.0 || attitude.yaw < -1.0 {
                    self.submitSelection(userAcceleration)
                    return
                }
                
                if rotation.x < -3.0 {
                    if answerCBool {
                        self.selectAnswer(answer: "A")
                    }
                    if answerDBool {
                        self.selectAnswer(answer: "B")
                    }
                }
                
                if rotation.x > 3.0 {
                    if answerABool {
                        self.selectAnswer(answer: "C")
                    }
                    if answerBBool {
                        self.selectAnswer(answer: "D")
                    }
                }
                
                if rotation.y < -3.0 {
                    if answerBBool {
                        self.selectAnswer(answer: "A")
                    }
                    if answerDBool {
                        self.selectAnswer(answer: "C")
                    }
                }
                
                if rotation.y > 3.0 {
                    if answerABool {
                        self.selectAnswer(answer: "B")
                    }
                    if answerCBool {
                        self.selectAnswer(answer: "D")
                    }
                }
            }
    
        }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.motionManager.stopDeviceMotionUpdates()
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        if motion == .motionShake {
            // TODO: pick a random item
            let optionsList = ["A","B","C","D"]
            let randomList = (GKRandomSource.sharedRandom().arrayByShufflingObjects(in: optionsList) as! [String])
            self.selectAnswer(answer: randomList[0])
        }
        
    }
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        print("motionEnded")
    }
    
    func back(sender: UIBarButtonItem) {
        self.game?.endGame()
        do{
            let data =  NSKeyedArchiver.archivedData(withRootObject: "GO_BACK")
            try self.session?.send(data, toPeers: (self.session?.connectedPeers)!, with: .unreliable)
        }
        catch let err {
            print("Error in sending data \(err)")
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func nextQuestion() {
        timerRunning = true;
        question = game?.nextQuestion(renderTimerCallback: renderTimer, timeEndedCallback: questionTimerEnded)
        QuestionLabel.text = question?.question
        answerALabel.text = question?.options["A"]
        answerBLabel.text = question?.options["B"]
        answerCLabel.text = question?.options["C"]
        answerDLabel.text = question?.options["D"]
        
        if(question == nil){
            submitButton.isHidden = true
            restartQuizButton.isHidden = false
            timerLabel.textColor = UIColor.black
            timerLabel.text = "Your Score: \((self.game?.players[0].score)!)"
        } else {
            submitButton.isHidden = false
            restartQuizButton.isHidden = true
        }
    }
    
    func renderTimer(timeRemaining: Int) {
        // TODO: render timer
        timerLabel.text = String(timeRemaining)
        if(timeRemaining < 6){ timerLabel.textColor = UIColor.red}
        else{ timerLabel.textColor = UIColor.black}
        
    }
    
    func questionTimerEnded() {
        timerRunning = false;
        var pointsArray = game?.awardPointsToPlayers()
        
        if(selectedOption != nil && question.checkSelection(selectedOption!)){
            print("correct answer")
            timerLabel.text = "Correct"
            submitButton.isHidden = true
        }
        else{
            timerLabel.text = "Incorrect"
            submitButton.isHidden = true
        }
        let player1Points = pointsArray?[0]
        player1Score.text = String(player1Points!)
        let player2Points = pointsArray?[1]
        player2Score.text = String(player2Points!)
        if (pointsArray?.count)! > 2 {
            let player3Points = pointsArray?[2]
            player3Score.text = String(player3Points!)
        }
        
        if (pointsArray?.count)! > 2 {
            let player4Points = pointsArray?[3]
            player4Score.text = String(player4Points!)
        }

        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(nextQuestion), userInfo: nil, repeats: false)
    }
    
    @IBAction func submitSelection(_ sender: Any) {
        if timerRunning && (answerABool || answerBBool || answerCBool || answerDBool) {
            game?.submitSelection(selectedOption!)
        }
    }
    
    @IBAction func restartQuizAction(_ sender: Any) {
        do{
            let data =  NSKeyedArchiver.archivedData(withRootObject: "NEW_GAME")
            try self.session?.send(data, toPeers: (self.session?.connectedPeers)!, with: .unreliable)
        }
        catch let err {
            print("Error in sending data \(err)")
        }
        
        game?.loadNewQuiz()
        self.nextQuestion()
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // this needs to be run on the main thread
        DispatchQueue.main.async(execute: {
            let playerIndex = (self.game?.getPlayerIndex(by:peerID))!
            if let receivedString = NSKeyedUnarchiver.unarchiveObject(with: data) as? String {
                switch receivedString {
                case "NEW_GAME":
                    self.game?.loadNewQuiz()
                    self.nextQuestion()
                case "GO_BACK":
                    _ = self.navigationController?.popViewController(animated: true)
                default:
                    self.game?.setPlayerSelectedAnswer(playerIndex: playerIndex, answer: receivedString)
                }
            }
        })
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
    }
    
}
