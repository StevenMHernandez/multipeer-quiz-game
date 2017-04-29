import Foundation

class JsonQuizLoader {
    var nextQuizNumber = 0
    var jsonQuestions:Question!
    var topic = ""
    var jsonQuestion = [Question]()
    var number = 0
    var numQuestions = 0
    var question = ""
    var answer = ""
    var options = [String:String]()
    let semaphore = DispatchSemaphore(value: 0)
    
    
    func loadNextQuiz() -> Quiz {
        self.jsonQuestion = [Question]() // clear our questions
        nextQuizNumber += 1
        return self.loadJsonQuiz(quizNumber: nextQuizNumber)
    }
    
    func loadJsonQuiz(quizNumber: Int) -> Quiz {
        jsonQuestion = getJSONData()
        let topic = "General"
        return Quiz(questions: jsonQuestion, topic: topic)
    }
    
    func getJSONData() -> [Question]{
        //var quiz: Quiz
        let urlString = "http://www.people.vcu.edu/~ebulut/jsonFiles/quiz\(nextQuizNumber).json"
        let url = URL(string: urlString)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!, completionHandler: {(data,respose, error) in
            
            if let result = data{
                print("inside get JSON")
                do{
                    let json = try JSONSerialization.jsonObject(with: result, options: .allowFragments)
                    
                    if let dictionary = json as? [String:Any]{
                        self.numQuestions = dictionary["numberOfQuestions"] as! Int
                        self.topic = dictionary["topic"] as! String
                        
                        let questions = dictionary["questions"] as! [Any]
                        questions.forEach({ (question) in
                            let q: [String:Any] = question as! [String : Any]
                            self.number = q["number"] as! Int
                            self.question = q["questionSentence"] as! String
                            self.answer = q["correctOption"] as! String
                            self.options = q["options"]  as! [String:String]
                            var optionsForAnswers = [String:String]()
                            self.options.forEach({ (key,option) in //change to map
                                optionsForAnswers[key] = option
                            })
                            self.jsonQuestion.append(Question(number: self.number, question: self.question, options: optionsForAnswers, correctOption: self.answer))
                        })
                        
                        self.semaphore.signal()
                    }
                }
                catch{
                    print("json file must not exist", urlString)
                    self.semaphore.signal()
                }
            }
            
        })
        task.resume()
        _ = self.semaphore.wait(timeout: .distantFuture)
        
        if (jsonQuestion.isEmpty) {
            // json file must not exist, let's default back to quiz 1
            self.nextQuizNumber = 1
            self.getJSONData()
        }
        
        return jsonQuestion
        
    }
}
