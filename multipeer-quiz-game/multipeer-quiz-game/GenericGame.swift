import Foundation

// Think of this as an `abstract` class

// Protocols show the attributes for the class
protocol GenericGame {
    var players: [Player] {get set}
    var currentPlayer: Player {get set}
    var timer: QuestionTimer {get set}
    var jsonQuizLoader: JsonQuizLoader {get}
    var quiz: Quiz? {get set}
}

// Extensions show the functions that the child class can extend
extension GenericGame {
    
    func canStartGame() -> Bool { return false }
    
    mutating func loadNewQuiz() {
        self.quiz = self.jsonQuizLoader.loadNextQuiz()
        
        // TODO: reset player's score to 0
    }
    
    func nextQuestion(renderTimerCallback: @escaping ((Int) -> Void), timeEndedCallback: @escaping (() -> Void)) -> Question? {
        let question = quiz?.getNextQuestion()

        // TODO: only start this timer if question is not `nil`
        timer.startQuestionTimer(renderTimerCallback: renderTimerCallback, timeEndedCallback: timeEndedCallback)
        
        return question
    }
    
    func submitSelection(_ choice: String) { }
    
    func checkAnswer(choice: String) -> Bool {
        // TODO: check if the answer is correct for the current question
        return false
    }
    
}
