import Foundation
import MultipeerConnectivity

// Think of this as an `abstract` class

// Protocols show the attributes and method for the class that must be set
protocol GenericGame {
    var players: [Player] {get set}
    var timer: QuestionTimer {get set}
    var jsonQuizLoader: JsonQuizLoader {get}
    var quiz: Quiz? {get set}
    func canStartGame() -> Bool
    func submitSelection(_ choice: String)
    func awardPointsToPlayers() -> [Int]
    func setPlayerSelectedAnswer(playerIndex: Int, answer: String)
}

// Extensions show the base methods (not extended)
extension GenericGame {
    
    mutating func loadNewQuiz() {
        self.quiz = self.jsonQuizLoader.loadNextQuiz()
        
        self.players[0].score = 0
    }
    
    func nextQuestion(renderTimerCallback: @escaping ((Int) -> Void), timeEndedCallback: @escaping (() -> Void)) -> Question? {
        let question = quiz?.getNextQuestion()
        
        if question != nil {
            timer.startQuestionTimer(renderTimerCallback: renderTimerCallback, timeEndedCallback: timeEndedCallback)
        }
        
        return question
    }
    
    func checkAnswer(choice: String) -> Bool {
        if(choice != ""){
            return choice == self.quiz?.questions[(self.quiz?.currentQuestion)!].correctOption
        }
        else{return false}
    }
    
    func getPlayerIndex(by peerID: MCPeerID) -> Int {
        for (index, player) in self.players.enumerated() {
            if (player.peerId == peerID) {
                return index
            }
        }
        
        return -1
    }
    
    func endGame() {
        self.timer.stop()
    }
}
