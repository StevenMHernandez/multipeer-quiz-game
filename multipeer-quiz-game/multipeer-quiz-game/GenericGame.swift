import Foundation

// Think of this as an `abstract` class

// Protocols show the attributes and method for the class that must be set
protocol GenericGame {
    var players: [Player] {get set}
    var timer: QuestionTimer {get set}
    var jsonQuizLoader: JsonQuizLoader {get}
    var quiz: Quiz? {get set}
    func canStartGame() -> Bool
    func submitSelection(_ choice: String)
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
        return choice == self.quiz?.questions[(self.quiz?.currentQuestion)!].correctOption
    }

}
