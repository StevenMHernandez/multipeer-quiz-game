import Foundation


class SinglePlayerGame: GenericGame {
    var players = [Player]()
    var timer = QuestionTimer()
    var jsonQuizLoader = JsonQuizLoader()
    var quiz: Quiz?
    
    init(currentPlayer: Player) {
        self.players.append(currentPlayer)
    }
    
    func canStartGame() -> Bool {
        // There is never anything preventing a user from player from
        // playing single player, so always return true.
        return true
    }
    
    func submitSelection(_ choice: String) {
        if self.checkAnswer(choice: choice) {
            self.players[0].awardPoints()
        }
        
        self.timer.stop()
    }
}
