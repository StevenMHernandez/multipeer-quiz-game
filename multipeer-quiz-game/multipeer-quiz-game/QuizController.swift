import UIKit

class QuizController: UIViewController {
    
    /*
     * This could either be a multiplayer or singleplayer quiz.
     * but because we don't care which it is in this controller
     * we just consider it a generic game.
     * When we call methods on this game (such as game.nextQuestion())
     * we don't worry about how we handle single vs multiplayer games
     * we let this object handle that logic itself
     */
    
    var game: SinglePlayerGame?
    
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
    var answerABool = false
    var answerBBool = false
    var answerCBool = false
    var answerDBool = false
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first{
            if touch.view == self.answerALabel {
                answerAView.backgroundColor = UIColor.yellow
                answerBView.backgroundColor = UIColor.lightGray
                answerCView.backgroundColor = UIColor.lightGray
                answerDView.backgroundColor = UIColor.lightGray
                answerABool = true; answerBBool = false
                answerCBool = false; answerDBool = false
                selectedOption = answerALabel.text
            } else if touch.view == self.answerBLabel {
                answerAView.backgroundColor = UIColor.lightGray
                answerBView.backgroundColor = UIColor.yellow
                answerCView.backgroundColor = UIColor.lightGray
                answerDView.backgroundColor = UIColor.lightGray
                answerABool = false; answerBBool = true
                answerCBool = false;  answerDBool = false
                selectedOption = answerBLabel.text
            } else if touch.view == self.answerCLabel {
                answerAView.backgroundColor = UIColor.lightGray
                answerBView.backgroundColor = UIColor.lightGray
                answerCView.backgroundColor = UIColor.yellow
                answerDView.backgroundColor = UIColor.lightGray
                answerABool = false; answerBBool = false
                answerCBool = true; answerDBool = false
                selectedOption = answerCLabel.text
            } else if touch.view == self.answerDLabel {
                answerAView.backgroundColor = UIColor.lightGray
                answerBView.backgroundColor = UIColor.lightGray
                answerCView.backgroundColor = UIColor.lightGray
                answerDView.backgroundColor = UIColor.yellow
                answerABool = false; answerBBool = false
                answerCBool = false; answerDBool = true
                selectedOption = answerDLabel.text
            } else{
                print("touch Registered")
                return
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "General"
        
        // TODO: remove this line
        // it should be sent over from the previous ViewController
        // it could either be SinglePlayerGame or MultiplayerGame
        self.game = SinglePlayerGame(currentPlayer: Player(peerId: 123456789, shortname: "User1"))
        
        jsonQuiz.getJSONData()
        game?.loadNewQuiz()
        
        
        // Load first Question:
        self.nextQuestion()
    }
    
    func nextQuestion() {
        submitButton.isHidden = false
        question = game?.nextQuestion(renderTimerCallback: renderTimer, timeEndedCallback: questionTimerEnded)
        QuestionLabel.text = question?.question
        answerALabel.text = question?.options["A"]
        answerBLabel.text = question?.options["B"]
        answerCLabel.text = question?.options["C"]
        answerDLabel.text = question?.options["D"]
        
        if(question == nil){
            restartQuizButton.isHidden = false
            timerLabel.textColor = UIColor.black
            timerLabel.text = "Your Score: \(players)"
        }
        
        //********************
        //done
        // TODO: if question is `nil`, that means there are no more questions for this quiz
        // TODO: notify user with `You Win`, `You Lose`, etc.
        // TODO: if user clicks `restart`, run this: `game?.loadNewQuiz()` and reload the interface
        // else, there are questions, so:
        //********************
        
        
        // TODO: render question and choice boxes
        
        // player is allowed to click their choice
        // after clicking, they can tilt their phone to change their selection
        // or shake to pick something random
        
        // Submit happens by acceleration in the `z` direction
        // or yaw in each direction
    }
    
    func renderTimer(timeRemaining: Int) {
        // TODO: render timer
        timerLabel.text = String(timeRemaining)
        if(timeRemaining < 6){ timerLabel.textColor = UIColor.red}
        else{ timerLabel.textColor = UIColor.black}
        
    }
    
    func questionTimerEnded() {
        // check if answer is correct
        // add points if so
        
        // show correct answer
        // wait `n` seconds before continuing
        
        
        
        
        if(selectedOption != nil && question.checkSelection(selectedOption!)){
            
            print("correct answer")
            timerLabel.text = "Correct"
            submitButton.isHidden = true
        }
        else{
            timerLabel.text = "incorrect"
            submitButton.isHidden = true
        }
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(nextQuestion), userInfo: nil, repeats: false)
        //self.nextQuestion()
    }
    
    @IBAction func submitSelection(_ sender: Any) {
        // TODO: only submit if something was selected
        if(answerABool || answerBBool || answerCBool || answerDBool){
            game?.submitSelection(selectedOption!)
            print("hello")
        }
        
    }
    
    
    @IBAction func restartQuizAction(_ sender: Any) {
        //TODO: Start quiz over when pressed
        game?.loadNewQuiz()
    }
}
