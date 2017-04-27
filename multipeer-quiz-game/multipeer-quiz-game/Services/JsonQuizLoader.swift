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
        questions.append(Question(number: 1, question: "What is the capital of USA?", options: options, correctOption: "D.C."))
        var options2 = [String: String]()
        options2["A"] = "D.C."
        options2["B"] = "London"
        options2["C"] = "Rome"
        options2["D"] = "New York"
        questions.append(Question(number: 2, question: "Which option says London?", options: options2, correctOption: "London"))
        // End of hardcoded quiz values
        
        
        
        return Quiz(questions: questions, topic: topic)
        
    }
    
    //reads from local JSON File
    //    func readLocalJSONData(){
    //        print("inside read local JSON")
    //
    //        let url = Bundle.main.url(forResource: "data", withExtension: "json")
    //        let data = try? Data(contentsOf: url!)
    //
    //        do {
    //
    //            let object = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
    //            if let dictionary = object as? [String: AnyObject] {
    //               print(dictionary["questionSentence"])
    //            }
    //
    //        } catch {
    //            // Handle Error
    //        }
    //    }
    
    
    
    //professors code tweaked around
    //TODO Find how to get information from dictionary into quiz
    func getJSONData(){
        //var quiz: Quiz
        let urlString = "http://www.people.vcu.edu/~ebulut/jsonFiles/quiz2.json"
        let url = URL(string: urlString)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!, completionHandler: {(data,respose, error) in
            if let result = data{
                
                print("inside get JSON")
                do{
                    let json = try JSONSerialization.jsonObject(with: result, options: .allowFragments)
                    
                    if let dictionary = json as? [String:Any]{
                        let topic = dictionary["topic"]
                        let questions: [String:Any] = dictionary["questions"] as! [String : Any]
                        questions.forEach({ (question) in
                            let q: [String:Any] = questions 
                            let number = q["number"] as! Int
                            let question = q["questionSentence"] as! String
                            let answer = q["correctOption"] as! String
                            let options = q["options"]  as! [String:Any]
                            options.forEach({ (option) in //change to map
                                let answers: [String: String] = options as! [String : String]
                             
                            })
                        })
                     
                        
                        
                    }
                }
                catch{
                    print("Error")
                }
            }
            
        })
        task.resume()
    }
}
