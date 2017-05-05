import Foundation

class Quiz {
    var questions: [Question]
    var topic: String

    var currentQuestion = -1
    
    init (questions: [Question], topic: String) {
        self.questions = questions
        self.topic = topic
    }
    
    func getNextQuestion() -> Question? {
        self.currentQuestion += 1
        
        if (self.questions.count <= self.currentQuestion) {
            return nil
        }
        
        return self.questions[self.currentQuestion]
    }
}
