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
    
    private func checkIfEveryOneIsDone() {
        // check if everyone has made a choice:
        for (_, player) in self.players.enumerated() {
            if player.selectedAnswer == "" {
                print("NOT DONE:", player, player.peerId.displayName)
                return // because we need to wait until this player selects an answer
            }
        }
        
        self.timer.stop()
    }
    
    func awardPointsToPlayers() {
        for (i, player) in self.players.enumerated() {
            print("player", i, player.selectedAnswer)
            if self.checkAnswer(choice: player.selectedAnswer) {
                player.awardPoints()
            }
        }
    }
}
