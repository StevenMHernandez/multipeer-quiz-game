import Foundation

class MultiPlayerGame: GenericGame {
    var players = [Player]()
    var timer = QuestionTimer()
    var jsonQuizLoader = JsonQuizLoader()
    var quiz: Quiz?
    
    init(currentPlayer: Player) {
        self.players.append(currentPlayer)
    }
    
    func canStartGame() -> Bool {
        return players.count > 1 && players.count <= 4
    }
    
    func submitSelection(_ choice: String) {
        self.players[0].selectedAnswer = choice
        
        self.checkIfEveryOneIsDone()
    }
    
    func markPlayerComplete() {
        // TODO: set player's selected answer
        self.checkIfEveryOneIsDone()
    }
    
    private func checkIfEveryOneIsDone() {
        // check if everyone has made a choice:
        for (_, player) in self.players.enumerated() {
            if player.selectedAnswer == "" {
                return // because we need to wait until this player selects an answer
            }
        }
        
        if self.checkAnswer(choice: self.players[0].selectedAnswer) {
            self.players[0].awardPoints()
        }
        
        // TODO: we need to rerender the other players scores here.
        
        self.timer.stop()
    }
}
