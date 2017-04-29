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
        nextQuizNumber += 1
        return self.loadJsonQuiz(quizNumber: nextQuizNumber)
    }
    
    func loadJsonQuiz(quizNumber: Int) -> Quiz {
        
        
        // TODO: build .json url with the `nextQuizNumber`
        // ex: `http://www.people.vcu.edu/~ebulut/jsonFiles/quiz2.json`
        // load from this url
        // if we get a 404, set quizNumber = 1 and retry once
        // parse json for questions and topic
        
        
        
        
        jsonQuestion = getJSONData()
            let topic = "General"
//        }
//            
//        else{
//            let topic = "Science and Technology"
//            var options = [String: String]()
//            options["A"] = "Rome"
//            options["B"] = "London"
//            options["C"] = "D.C."
//            options["D"] = "New York"
//            jsonQuestion.append(Question(number: 1, question: "What is the capital of USA?", options: options, correctOption: "C"))
//            var options2 = [String: String]()
//            options2["A"] = "D.C."
//            options2["B"] = "London"
//            options2["C"] = "Rome"
//            options2["D"] = "New York"
//            jsonQuestion.append(Question(number: 2, question: "Which option says London?", options: options2, correctOption: "B"))
//        }
//        
        
        
        //jsonQuestion.append(Question(number: self.number, question: question as! String, options: optionsForAnswers, correctOption: self.answer))
        
        
        return Quiz(questions: jsonQuestion, topic: topic)
        
        
        
        
        
    }
    
    
    //TODO Find how to get information from dictionary into quiz
    func getJSONData() -> [Question]{
        //var quiz: Quiz
        let urlString = "http://www.people.vcu.edu/~ebulut/jsonFiles/quiz\(nextQuizNumber).json"
        let url = URL(string: urlString)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!, completionHandler: {(data,respose, error) in
            
            if let result = data{
                _ = self.semaphore.wait(timeout: .distantFuture)
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
                       
                    }
                }
                catch{
                    print("Error")
                }
            }
            
        })
        semaphore.signal()
        task.resume()
        return jsonQuestion
        
    }
}
