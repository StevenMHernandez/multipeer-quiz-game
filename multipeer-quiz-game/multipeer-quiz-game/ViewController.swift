//
//  ViewController.swift
//  multipeer-quiz-game
//
//  Created by Steven Hernandez on 4/20/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var segmentedControlForPlayer: UISegmentedControl!
    @IBOutlet weak var startGameButton: UIButton!
    var numPlayers = Int()
    @IBAction func segmentedControlUpdated(_ sender: Any) {
        switch self.segmentedControlForPlayer.selectedSegmentIndex
        {
        case 0:
            print("0")
            numPlayers = 0
            
        case 1:
            print("1")
            numPlayers = 1
        default:
            break;
        }
    }
    
    @IBAction func buttonPress(_ sender: Any) {
        if(numPlayers == 0){
            performSegue(withIdentifier: "toQuiz", sender: self)
        }
        else{
            let alert = UIAlertController(title: "Error", message: "Not enough People", preferredStyle: .alert)
            
            let myAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(myAction)
            
            present(alert, animated: true, completion: nil)

        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


