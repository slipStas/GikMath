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
    
    enum Difficulty: String {
        case easy = "easy"
        case simple = "simple"
        case normal = "normal"
        case medium = "meduim"
        case hard = "hard"
        case veryHard = "very hard"
        case extreme = "extreme"
    }
    
    var historyArray : [Math] = []
    var counterArray : [Int] = []
    
    var counterBeetwenTrueAndFalse = 0
    var avarageCounterValue : Double {
        get {
            if counterArray.count == 0 {
                return 0.0
            } else {
                var count = 0
                var total = 0
                for i in counterArray {
                    total += i
                    count += 1
                }
                print(counterArray)
                let avarage = Double(total) / Double(count)
                return Double(String(format: "%.2f", avarage))!
            }
        }
    }
    var difficultyLevel = Difficulty.easy {
        didSet {
            print(self.difficultyLevel.rawValue)
            print(avarageCounterValue)
            

            UIView.transition(with: levelLabel,
                              duration: 0.7,
                              options: .transitionCrossDissolve,
                              animations: {
                switch self.difficultyLevel {
                case .easy:
                    self.levelLabel.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                case .simple:
                    self.levelLabel.textColor = #colorLiteral(red: 0, green: 0.5647058824, blue: 0.3176470588, alpha: 1)
                case .normal:
                    self.levelLabel.textColor = #colorLiteral(red: 0.5725490196, green: 0.5647058824, blue: 0, alpha: 1)
                case .medium:
                    self.levelLabel.textColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
                case .hard:
                    self.levelLabel.textColor = #colorLiteral(red: 1, green: 0.1490196078, blue: 0, alpha: 1)
                case .veryHard:
                    self.levelLabel.textColor = #colorLiteral(red: 0.5803921569, green: 0.06666666667, blue: 0, alpha: 1)
                case .extreme:
                    self.levelLabel.textColor = #colorLiteral(red: 0.2666666667, green: 0.06666666667, blue: 0, alpha: 1)
                }
            })

            
        }
    }
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
    var counter = 0.0 {
        didSet {
            if self.counter > 3599.99 {
                countFalse += 1
                self.counter = 0.0
                timer!.invalidate()
                timer = nil
                startTimer(tableView: historyTableView)
            }
        }
    }
    var timeArray: [Double] = []

    func startTimer(tableView: UITableView) {
        generateMath()
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
    
    @IBOutlet weak var levelLabel: UILabel!
    
    
    @IBAction func resetResultsButton(_ sender: Any) {
        feedback()
        countFalse = 0
        countTrue = 0
        counterArray.removeAll()
        counterBeetwenTrueAndFalse = 0
        if !historyArray.isEmpty {
            historyTableView.beginUpdates()
            for i in 0...historyArray.count - 1 {
                historyTableView.deleteRows(at: [IndexPath(row: i, section: 0)], with: .right)
            }
            historyArray.removeAll()
            historyTableView.endUpdates()
        }
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
        
        if Int(answerLabel.text!) == result {
            counterBeetwenTrueAndFalse += 1
            if counterArray.count > 0 {
                counterArray.removeLast()
            }
            counterArray.append(counterBeetwenTrueAndFalse)
            generator.notificationOccurred(.success)
            historyArray.insert(Math(value: theTaskLabel.text! + " " + answerLabel.text!, color: .green, time: timerLabel.text ?? "timer error", timeCounter: counter), at: 0)
            self.timeArray.append(counter)
            timerStop(tableView: historyTableView)
            
            historyTableView.beginUpdates()
            historyTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
            historyTableView.endUpdates()
            
            systemMessagesLabel.text?.removeAll()
            
            if Session.shared.countTrueAnswers < maxTrueOrFalseCount {
                countTrue += 1
            } else {
                systemMessagesLabel.text = "The maximum number of correct answers has been reached and counters are dropped"
                countTrue = 0
                countFalse = 0
            }
        } else {
            generator.notificationOccurred(.error)
            counterBeetwenTrueAndFalse = 0
            counterArray.append(counterBeetwenTrueAndFalse)
            
            if self.counter <= 2.0 {
                self.counter +=  (2.0 - self.counter ) * 1.3 + 0.5
            } else {
                self.counter += self.counter * 1.3
            }
            
            self.timeArray.append(counter)
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
            systemMessagesLabel.text = "You are wrong, correct answer: \(result)"
            
            if Session.shared.countFalseAnswers < maxTrueOrFalseCount {
                countFalse += 1
            } else {
                systemMessagesLabel.text? += "\nThe maximum number of incorrect answers has been reached and counters are dropped"
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
        case .easy, .simple:
            rand = arc4random_uniform(2)
        case .normal:
            rand = arc4random_uniform(3)
        case .medium, .hard, .extreme, .veryHard:
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
            leftNumber = Int(arc4random_uniform(60))
            rightNumber = Int(arc4random_uniform(60))
        case .medium:
            leftNumber = Int(arc4random_uniform(90))
            rightNumber = Int(arc4random_uniform(90))
        case .hard:
            leftNumber = Int(arc4random_uniform(110))
            rightNumber = Int(arc4random_uniform(110))
        case .veryHard:
            leftNumber = Int(arc4random_uniform(150))
            rightNumber = Int(arc4random_uniform(150))
        case .extreme:
            leftNumber = Int(arc4random_uniform(200))
            rightNumber = Int(arc4random_uniform(200))
        }
    }
    func generateFirstSecondNumbersForDiv() {
        switch self.difficultyLevel {
        case .medium, .hard:
            leftNumber = noZero(number: (Int(arc4random_uniform(10))))
            rightNumber = leftNumber * noZero(number: (Int(arc4random_uniform(10))))
        case .veryHard:
            leftNumber = noZero(number: (Int(arc4random_uniform(13))))
            rightNumber = leftNumber * noZero(number: (Int(arc4random_uniform(13))))
        case .extreme:
            leftNumber = noZero(number: (Int(arc4random_uniform(20))))
            rightNumber = leftNumber * noZero(number: (Int(arc4random_uniform(20))))
        default:
            return
        }
    }
    func generateFirstSecondNumbersForMult() {
        
        switch self.difficultyLevel {
        case .normal:
            leftNumber = noZero(number: Int(arc4random_uniform(5)))
            rightNumber = noZero(number: Int(arc4random_uniform(5)))
        case .medium:
            leftNumber = noZero(number: Int(arc4random_uniform(10)))
            rightNumber = noZero(number: Int(arc4random_uniform(10)))
        case .hard:
            leftNumber = noZero(number: Int(arc4random_uniform(12)))
            rightNumber = noZero(number: Int(arc4random_uniform(12)))
        case .veryHard:
            leftNumber = noZero(number: Int(arc4random_uniform(15)))
            rightNumber = noZero(number: Int(arc4random_uniform(15)))
        case .extreme:
            leftNumber = noZero(number: Int(arc4random_uniform(20)))
            rightNumber = noZero(number: Int(arc4random_uniform(20)))
        default:
            return
        }
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
        
        switch self.avarageCounterValue {
        case 0...4:
            self.difficultyLevel = .easy
        case 4.01...7:
            self.difficultyLevel = .simple
        case 7.01...11:
            self.difficultyLevel = .normal
        case 11.01...17:
            self.difficultyLevel = .medium
        case 17.01...23:
            self.difficultyLevel = .hard
        case 23.01...30:
            self.difficultyLevel = .veryHard
        case 30.01...Double(maxTrueOrFalseCount):
            self.difficultyLevel = .extreme
        default:
            return
        }
        
        countTrueLabel.text? = String(countTrue)
        countFalseLabel.text? = String(countFalse)
        answerLabel.text = "введите ответ"
        levelLabel.text = self.difficultyLevel.rawValue
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
        self.resetResultsButton.isEnabled = true
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
        self.resetResultsButton.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        disableNumbersButtons()
        startStopButton.setTitle("Start", for: .normal)
        theTaskLabel.text = """
        For starting tap "Start"
        """
        answerLabel.text?.removeAll()
        avarageTime.text?.removeAll()
        timerLabel.text?.removeAll()
        countTrueLabel.text?.removeAll()
        countFalseLabel.text?.removeAll()
        levelLabel.text?.removeAll()
        
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
        case 0...2:
            self.avarageTime.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        case 2...3.5:
            self.avarageTime.textColor = #colorLiteral(red: 0, green: 0.5647058824, blue: 0.3176470588, alpha: 1)
        case 3.501...7:
            self.avarageTime.textColor = #colorLiteral(red: 0.5725490196, green: 0.5647058824, blue: 0, alpha: 1)
        case 7...10:
            self.avarageTime.textColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
        case 10...15:
            self.avarageTime.textColor = #colorLiteral(red: 1, green: 0.1490196078, blue: 0, alpha: 1)
        default:
            self.avarageTime.textColor = #colorLiteral(red: 0.5803921569, green: 0.06666666667, blue: 0, alpha: 1)
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
