import Foundation
import MultipeerConnectivity

class MultiPlayerGame: GenericGame {
    var players = [Player]()
    var timer = QuestionTimer()
    var jsonQuizLoader = JsonQuizLoader()
    var quiz: Quiz?
    var session: MCSession?
    
    init(currentPlayer: Player, session: MCSession) {
        self.players.append(currentPlayer)
        self.session = session
    }
    
    func canStartGame() -> Bool {
        return players.count > 1 && players.count <= 4
    }
    
    func submitSelection(_ choice: String) {
        self.players[0].selectedAnswer = choice
        
        do{
            let data =  NSKeyedArchiver.archivedData(withRootObject: choice)
            try self.session?.send(data, toPeers: (self.session?.connectedPeers)!, with: .unreliable)
        }
        catch let err {
            print("Error in sending data \(err)")
        }
        
        self.checkIfEveryOneIsDone()
    }
    
    func checkIfEveryOneIsDone() {
        // check if everyone has made a choice:
        for (_, player) in self.players.enumerated() {
            if player.selectedAnswer == "" {
                return // because we need to wait until this player selects an answer
            }
        }
        
        self.timer.stop()
    }
    
    func awardPointsToPlayers() -> [Int]{
        var pointsArray = [Int]()
        for (i, player) in self.players.enumerated() {
            print("player", i, player.selectedAnswer)
            if self.checkAnswer(choice: player.selectedAnswer) {
                player.awardPoints()
            }
            pointsArray.append(player.score)
            player.selectedAnswer = ""
        }
        
        return pointsArray
    }
    
    func setPlayerSelectedAnswer(playerIndex: Int, answer: String) {
        self.players[playerIndex].selectedAnswer = answer
        self.checkIfEveryOneIsDone()
    }
}
