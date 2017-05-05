import Foundation

class Question {
    var number: Int
    var question: String
    var options: [String: String]
    var correctOption: String
    
    init(number: Int, question: String, options: [String: String], correctOption: String) {
        self.number = number
        self.question = question
        self.options = options
        self.correctOption = correctOption
    }
    
    func checkSelection(_ choice: String) -> Bool {
        // TODO: check if the chioce is correct
        if(choice == correctOption){
            return true
        }
        else{
            return false
        }
    }
}
