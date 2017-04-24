import Foundation

class QuestionTimer {
    var timer: Timer?
    var timeRemaining = 0
    
    var renderTimerCallback: ((Int) -> Void)?
    var timeEndedCallback: (() -> Void)?
    
    func startQuestionTimer(renderTimerCallback: @escaping ((Int) -> Void), timeEndedCallback: @escaping (() -> Void)) {
        self.renderTimerCallback = renderTimerCallback
        self.timeEndedCallback = timeEndedCallback
        
        self.timeRemaining = 20
        
        self.renderTimerCallback!(self.timeRemaining)
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(QuestionTimer.decrementTimeRemaining), userInfo: nil, repeats: true)
    }
    
    @objc func decrementTimeRemaining() {
        self.timeRemaining -= 1
        
        self.renderTimerCallback!(self.timeRemaining)
        //figure out why this is running twice
        
        if self.timeRemaining == 0 {
            self.stop()
        }
    }
    
    func stop() {
        self.timer?.invalidate()
        self.timeEndedCallback!()
    }
}
