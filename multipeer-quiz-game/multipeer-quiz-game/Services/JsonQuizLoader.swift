import Foundation

class JsonQuizLoader {
    var nextQuizNumber = 1
    
    
    func loadNextQuiz() -> Quiz {
        nextQuizNumber += 1
        
        return self.loadJsonQuiz(quizNumber: nextQuizNumber - 1)
    }
    
    private func loadJsonQuiz(quizNumber: Int) -> Quiz {
        var questions = [Question]()
        
        // TODO: build .json url with the `nextQuizNumber`
        // ex: `http://www.people.vcu.edu/~ebulut/jsonFiles/quiz2.json`
        
        // load from this url
        // if we get a 404, set quizNumber = 1 and retry once
        
        // parse json for questions and topic
        
        
        
        // REMOVE: these are just harcoded for testing initially.
        let topic = "Science and Technology"
        var options = [String: String]()
        options["A"] = "Rome"
        options["B"] = "London"
        options["C"] = "D.C."
        options["D"] = "New York"
        questions.append(Question(number: 1, question: "What is the capital of USA?", options: options, correctOption: "C"))
        var options2 = [String: String]()
        options2["A"] = "D.C."
        options2["B"] = "London"
        options2["C"] = "Rome"
        options2["D"] = "New York"
        questions.append(Question(number: 2, question: "What is the capital of USA?", options: options2, correctOption: "A"))
        // End of hardcoded quiz values
        
        
        
        return Quiz(questions: questions, topic: topic)
    }
}
