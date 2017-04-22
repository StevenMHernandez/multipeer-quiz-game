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
        // TODO: increment currentQuestion
        // if question[currentQuestion] doesn't exist, return nil otherwise return the next question
        
        // TODO: return question
        return nil
    }
}
