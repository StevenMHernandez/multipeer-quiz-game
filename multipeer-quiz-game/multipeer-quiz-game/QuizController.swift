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
    var game: GenericGame?
    
    var selectedOption: String?
    
    @IBOutlet weak var mainLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: remove this line
        // it should be sent over from the previous ViewController
        // it could either be SinglePlayerGame or MultiplayerGame
        self.game = SinglePlayerGame(currentPlayer: Player(peerId: 123456789, shortname: "User1"))
        
        game?.loadNewQuiz()
        
        // Load first Question:
        self.nextQuestion()
    }
    
    func nextQuestion() {
        let question = game?.nextQuestion(renderTimerCallback: renderTimer, timeEndedCallback: questionTimerEnded)
        
        // TODO: if question is `nil`, that means there are no more questions for this quiz
            // TODO: notify user with `You Win`, `You Lose`, etc.
            // TODO: if user clicks `restart`, run this: `game?.loadNewQuiz()` and reload the interface
        // else, there are questions, so:
            // TODO: render question and choice boxes
        
                // player is allowed to click their choice
                // after clicking, they can tilt their phone to change their selection
                // or shake to pick something random
        
                // Submit happens by acceleration in the `z` direction
                // or yaw in each direction
    }
    
    func renderTimer(timeRemaining: Int) {
        // TODO: render timer
        print(timeRemaining)
    }
    
    func questionTimerEnded() {
        // check if answer is correct
        // add points if so
        
        // show correct answer
        // wait `n` seconds before continuing
        
        self.nextQuestion()
    }
    
    func submitSelection() {
        // TODO: only submit if something was selected
        game?.submitSelection(self.selectedOption!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
