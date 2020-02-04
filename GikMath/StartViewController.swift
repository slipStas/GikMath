//
//  StartViewController.swift
//  GikMath
//
//  Created by Stanislav Slipchenko on 19.01.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    enum Operation: String {
        case subt = "-"
        case add = "+"
        case mult = "*"
        case div = "/"
    }
    
    enum Difficulty {
        case easy
        case simple
        case normal
        case medium
        case hard
        case veryHard
        case extreme
    }
    
    var historyArray : [Math] = []
    
    var difficultyLevel = Difficulty.easy
    var leftNumber: Int = 0
    var rightNumber: Int = 0
    var operation = ""
    var result: Int = 0
    var maxTrueOrFalseCount = 999
    var countTrue = 0 {
        willSet {
            Session.shared.countTrueAnswers = newValue
            countTrueLabel.text = String(newValue)
            
            if newValue == maxTrueOrFalseCount {
                countTrueLabel.text = String(0)
                countFalseLabel.text = String(0)
                systemMessagesLabel.text = "Достигнуто максимальное количество верных ответов, счетчики сбросились"
            }
        }
        didSet {
            UIView.transition(with: countTrueLabel, duration: 0.7, options: .transitionFlipFromBottom, animations: {})
            
            if countTrue == maxTrueOrFalseCount || countFalse == maxTrueOrFalseCount {
                countTrue = 0
                countFalse = 0
            }
        }
    }
    var countFalse = 0 {
        willSet {
            Session.shared.countFalseAnswers = newValue
            countFalseLabel.text = String(newValue)
            
            if newValue == maxTrueOrFalseCount {
                countTrueLabel.text = String(0)
                countFalseLabel.text = String(0)
                systemMessagesLabel.text = "Достигнуто максимальное количество неверных ответов, счетчики сбросились"
            }
        }
        didSet {
            UIView.transition(with: countFalseLabel, duration: 0.7, options: .transitionFlipFromBottom, animations: {})
            
            if countFalse == maxTrueOrFalseCount || countTrue == maxTrueOrFalseCount {
                countTrue = 0
                countFalse = 0
            }
        }
    }
    
    var timer : Timer? = nil
    var counter = 0.0
    var timeArray: [Double] = []

    func startTimer(tableView: UITableView) {
        generateMath()
        resetResultsButton.isEnabled = true
        tableView.isScrollEnabled = false
        counter = 0.0
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
    }
    @objc func runTimer() {
        counter += 0.01
        startStopButton.setTitle("Stop", for: .normal)
        timerLabel.text = decimalToString(counter: counter)
    }
    func timerStop(tableView: UITableView) {
        tableView.isScrollEnabled = true
        guard timer != nil else {
            print("timer == nil")
            return
        }
        startStopButton.setTitle("Start", for: .normal)
        timer!.invalidate()
        timer = nil
    }
    func decimalToString(counter : Double) -> String {
        var text = ""
        let flooredCounter = Int(floor(counter))
        let minute = (flooredCounter % 3600) / 60
        var minuteString: String {
            get {
                if minute < 10 {
                    return "0\(minute)"
                } else {
                    return String(minute)
                }
            }
        }
        let sec = (flooredCounter % 3600) % 60
        var secString: String {
            get {
                if sec < 10 {
                    return "0\(sec)"
                } else {
                    return String(sec)
                }
            }
        }
        let deciSecond = String(format: "%.2f", counter).components(separatedBy: ".").last
        text = "\(minuteString):\(secString).\(deciSecond!)"
        return text
    }
    
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var nineButtton: UIButton!
    @IBOutlet weak var zeroButton: UIButton!
    @IBOutlet weak var backspaseButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var resetResultsButton: UIButton!
    
    
    @IBOutlet weak var startStopButton: UIButton!
    
    @IBOutlet weak var theTaskLabel: UILabel!
    
    @IBOutlet weak var answerLabel: UILabel!
    
    @IBOutlet weak var countTrueLabel: UILabel!
    
    @IBOutlet weak var countFalseLabel: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var systemMessagesLabel: UILabel!
    
    @IBOutlet weak var historyTableView: UITableView!
    
    @IBOutlet weak var avarageTime: UILabel!
    
    
    @IBAction func resetResultsButton(_ sender: Any) {
        feedback()
        countFalse = 0
        countTrue = 0
    }
    
    @IBAction func stopButton(_ sender: Any) {
        
        if timer != nil {
            feedback()
            timerStop(tableView: historyTableView)
            disableNumbersButtons()
        } else {
            feedback()
            startTimer(tableView: historyTableView)
            enableNumbersButtons()
        }
    }
    
    //MARK: check button
    @IBAction func checkButton(_ sender: Any) {
        let generator = UINotificationFeedbackGenerator()
        guard timer != nil else { return }
        self.timeArray.append(counter)
        
        if Int(answerLabel.text!) == result {
            generator.notificationOccurred(.success)
            historyArray.insert(Math(value: theTaskLabel.text! + " " + answerLabel.text!, color: .green, time: timerLabel.text ?? "timer error", timeCounter: counter), at: 0)
            timerStop(tableView: historyTableView)
            historyTableView.beginUpdates()
            historyTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
            historyTableView.endUpdates()
            systemMessagesLabel.text?.removeAll()
            
            if Session.shared.countTrueAnswers < maxTrueOrFalseCount {
                countTrue += 1
            } else {
                systemMessagesLabel.text = "Достигнуто максимальное количество верных ответов счетчики сбросились"
                countTrue = 0
                countFalse = 0
            }
        } else {
            generator.notificationOccurred(.error)
            timer!.invalidate()
            timer = nil
            switch answerLabel.text {
            case "введите ответ", "":
                historyArray.insert(Math(value: theTaskLabel.text! + " " + "(" + String(result) + ")", color: .red, time: timerLabel.text ?? "timer error", timeCounter: counter), at: 0)
                historyTableView.beginUpdates()
                historyTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
                historyTableView.endUpdates()
            default:
                historyArray.insert(Math(value: theTaskLabel.text! + " " + answerLabel.text! + " " + "(" + String(result) + ")", color: .red, time: timerLabel.text ?? "timer error", timeCounter: counter), at: 0)
                historyTableView.beginUpdates()
                historyTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
                historyTableView.endUpdates()
            }
            systemMessagesLabel.text = "Неверно, правильный ответ: \(result)"
            
            if Session.shared.countFalseAnswers < maxTrueOrFalseCount {
                countFalse += 1
            } else {
                systemMessagesLabel.text? += "\nДостигнуто максимальное количество неверных ответов счетчики сбросились"
                countTrue = 0
                countFalse = 0
            }
        }
        theTaskLabel.text!.removeAll()
        answerLabel.text!.removeAll()
        startTimer(tableView: historyTableView)
    }
    
    @IBAction func backspaseButton(_ sender: Any) {
        feedback()
        
        if (answerLabel.text?.count)! > 0 && answerLabel.text != "введите ответ" {
            answerLabel.text!.removeLast()
        }
    }
    
    @IBAction func pressedNumber(_ sender: Any) {
        feedback()
        
        if answerLabel.text!.first != nil && answerLabel.text != "введите ответ" && (sender as AnyObject).titleLabel!.text! == "-" {
            return
        }
        if answerLabel.text == "введите ответ" {
            answerLabel.text!.removeAll(keepingCapacity: false)
            answerLabel.alpha = 1
        }
        
        if (sender as AnyObject).titleLabel?.text != nil {
            answerLabel.text! += (sender as AnyObject).titleLabel!.text!
        }
    }
    
    func whatTheOperation() {
        var rand : UInt32 = 0
        
        switch self.difficultyLevel {
        case .easy, .simple, .normal:
            rand = arc4random_uniform(2)
        case .medium, .hard:
            rand = arc4random_uniform(3)
        case .extreme, .veryHard:
            rand = arc4random_uniform(4)
        }
        
        switch rand {
        case 0:
            operation = Operation.subt.rawValue
        case 1:
            operation = Operation.add.rawValue
        case 2:
            operation = Operation.mult.rawValue
        case 3:
            operation = Operation.div.rawValue
        default:
            break
        }
    }
    
    func noZero(number : Int) -> Int {
        
        if number == 0 {
            return 1
        } else {
            return number
        }
    }
    
    func generateFirstSecondNumbersNoDiv() {
        
        switch self.difficultyLevel {
        case .easy:
            leftNumber = Int(arc4random_uniform(10))
            rightNumber = Int(arc4random_uniform(10))
        case .simple:
            leftNumber = Int(arc4random_uniform(30))
            rightNumber = Int(arc4random_uniform(30))
        case .normal:
            leftNumber = Int(arc4random_uniform(90))
            rightNumber = Int(arc4random_uniform(90))
        case .medium:
            leftNumber = Int(arc4random_uniform(150))
            rightNumber = Int(arc4random_uniform(150))
        case .hard:
            leftNumber = Int(arc4random_uniform(300))
            rightNumber = Int(arc4random_uniform(300))
        case .veryHard:
            leftNumber = Int(arc4random_uniform(500))
            rightNumber = Int(arc4random_uniform(500))
        case .extreme:
            leftNumber = Int(arc4random_uniform(1000))
            rightNumber = Int(arc4random_uniform(1000))
        }
    }
    func generateFirstSecondNumbersForDiv() {
        leftNumber = noZero(number: (Int(arc4random_uniform(10))))
        rightNumber = leftNumber * noZero(number: (Int(arc4random_uniform(10))))
    }
    func generateFirstSecondNumbersForMult() {
        leftNumber = noZero(number: Int(arc4random_uniform(10)))
        rightNumber = noZero(number: Int(arc4random_uniform(10)))
    }
    func generateRandomNumbers() {
        
        switch operation {
            
        case "-":
            generateFirstSecondNumbersNoDiv()
            
            if leftNumber >= rightNumber {
                result = leftNumber - rightNumber
            } else {
                result = rightNumber - leftNumber
            }
        case "+":
            generateFirstSecondNumbersNoDiv()
            
            result = leftNumber + rightNumber
        case "*":
            
            generateFirstSecondNumbersForMult()
            
            result = leftNumber * rightNumber
        case "/":
            generateFirstSecondNumbersForDiv()
            
            result = rightNumber / leftNumber
        default:
            break
        }
    }
    func printLabelResult() {
        
        if operation == "-" && leftNumber < rightNumber || operation == "/" {
            theTaskLabel.text = String(rightNumber) + operation + String(leftNumber) + "  ="
        } else {
            theTaskLabel.text = String(leftNumber) + operation + String(rightNumber) + "  ="
        }
    }
    func generateMath() {
        answerLabel.text = "введите ответ"
        answerLabel.alpha = 0.5
        
        whatTheOperation()
        generateRandomNumbers()
        
        theTaskLabel.text?.removeAll()
        
        printLabelResult()
    }
    func feedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    func disableNumbersButtons() {
        self.oneButton.isEnabled = false
        self.twoButton.isEnabled = false
        self.threeButton.isEnabled = false
        self.fourButton.isEnabled = false
        self.fiveButton.isEnabled = false
        self.sixButton.isEnabled = false
        self.sevenButton.isEnabled = false
        self.eightButton.isEnabled = false
        self.nineButtton.isEnabled = false
        self.zeroButton.isEnabled = false
        self.minusButton.isEnabled = false
        self.backspaseButton.isEnabled = false
    }
    func enableNumbersButtons() {
        self.oneButton.isEnabled = true
        self.twoButton.isEnabled = true
        self.threeButton.isEnabled = true
        self.fourButton.isEnabled = true
        self.fiveButton.isEnabled = true
        self.sixButton.isEnabled = true
        self.sevenButton.isEnabled = true
        self.eightButton.isEnabled = true
        self.nineButtton.isEnabled = true
        self.zeroButton.isEnabled = true
        self.minusButton.isEnabled = true
        self.backspaseButton.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        disableNumbersButtons()
        resetResultsButton.isEnabled = false
        startStopButton.setTitle("Start", for: .normal)
        theTaskLabel.text = """
        For starting tap "Start"
        """
        answerLabel.text?.removeAll()
        avarageTime.text?.removeAll()
        timerLabel.text?.removeAll()
        countTrueLabel.text?.removeAll()
        countFalseLabel.text?.removeAll()
        
        historyTableView.rowHeight = 30
        systemMessagesLabel.text?.removeAll()
        avarageTime.text?.removeAll()
        historyTableView.dataSource = self
        historyTableView.delegate = self
    }
}

//MARK: Delegate
extension StartViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: DataSourse
extension StartViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCell(withIdentifier: "historyTableCell", for: indexPath) as! HistoryTableViewCell
        
        var count = 0.0
        var totalTime = 0.0
        var avarageTime : Double {
            get {
                return totalTime / count
            }
        }
        for i in historyArray {
            totalTime += i.timeCounter
            count += 1
        }
        
        self.avarageTime.text = decimalToString(counter: avarageTime)
        cell.historyLabel.text = historyArray[indexPath.row].value + "   " + historyArray[indexPath.row].time
        
        switch avarageTime {
        case 0...1:
            self.avarageTime.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        case 1.001...3:
            self.avarageTime.textColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
        case 3.001...5:
            self.avarageTime.textColor = #colorLiteral(red: 0.5738074183, green: 0.5655357838, blue: 0, alpha: 1)
        case 5.001...8:
            self.avarageTime.textColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        case 8.001...12:
            self.avarageTime.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        default:
            self.avarageTime.textColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)

        }
        switch historyArray[indexPath.row].color {
        case .green:
            cell.historyLabel.textColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
        case .red:
            cell.historyLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }
        return cell
    }
}
