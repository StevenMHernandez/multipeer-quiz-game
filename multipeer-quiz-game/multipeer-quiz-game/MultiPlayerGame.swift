import Foundation

class MultiPlayerGame: GenericGame {
    var players = [Player]()
    var currentPlayer: Player
    var timer = QuestionTimer()
    var jsonQuizLoader = JsonQuizLoader()
    var quiz: Quiz?
    
    init(currentPlayer: Player) {
        self.currentPlayer = currentPlayer
    }
    
    func canStartGame() -> Bool {
        // Check if there are enough player, or too many players etc.
        return false
    }
}
