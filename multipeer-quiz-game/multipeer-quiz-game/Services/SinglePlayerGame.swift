import Foundation


class SinglePlayerGame: GenericGame {
    var players = [Player]()
    var currentPlayer: Player
    var timer = QuestionTimer()
    var jsonQuizLoader = JsonQuizLoader()
    var quiz: Quiz?
    
    init(currentPlayer: Player) {
        self.currentPlayer = currentPlayer
    }
    
    func canStartGame() -> Bool {
        // There is never anything preventing a user from player from
        // playing single player, so always return true.
        return true
    }
    
    func submitSelection(_ choice: String) {
        // TODO: if `self.checkAnswer(choice: choice)`, add points to score
        
        self.timer.stop()
        self.timer.timeEndedCallback!()
    }
}
