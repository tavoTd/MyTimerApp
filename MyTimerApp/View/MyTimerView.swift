//
//  MyTimerView.swift
//  MyTimerApp
//
//  Created by Gustavo Tellez on 15/03/22.
//

import UIKit

class MyTimerView: UIViewController {
    
    private lazy var lbTime: UILabel = {
        let lb = UILabel()
        lb.isHidden = true
        lb.font = UIFont.systemFont(ofSize: 80.0)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private lazy var stackView: UIStackView = {
        let stack =  UIStackView()
        stack.spacing = 10
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var txtMinutes: UITextField = {
        let txt = UITextField()
        txt.textAlignment = .center
        txt.keyboardType = .asciiCapableNumberPad
        txt.backgroundColor = UIColor.white
        txt.layer.cornerRadius = 10.0
        txt.maxLength = 2
        txt.placeholder = "00"
        txt.font = UIFont.systemFont(ofSize: 30.0)
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    private lazy var lbSeparator: UILabel = {
        let lb = UILabel()
        lb.text = ":"
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 30.0)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private lazy var txtSeconds: UITextField = {
        let txt = UITextField()
        txt.textAlignment = .center
        txt.keyboardType = .asciiCapableNumberPad
        txt.backgroundColor = UIColor.white
        txt.layer.cornerRadius = 10.0
        txt.maxLength = 2
        txt.placeholder = "00"
        txt.font = UIFont.systemFont(ofSize: 30.0)
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    private lazy var btnCancel: UIButton = {
        let btn = UIButton()
        btn.setTitle("Terminar", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        btn.layer.cornerRadius = 15.0
        btn.isHidden = true
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25.0)
        btn.addTarget(self, action: #selector(btnCancelPressed(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var btnStart: UIButton = {
        let btn = UIButton()
        btn.setTitle("Iniciar", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        btn.layer.cornerRadius = 15.0
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25.0)
        btn.addTarget(self, action: #selector(btnStartPressed(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    public var viewModel: MyTimerViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My TimerApp"
        self.view.backgroundColor = #colorLiteral(red: 0, green: 0.1559211314, blue: 0.3993875384, alpha: 1)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        buildUI()
        buildConstraints()
    }
    
    func buildUI(){
        viewModel = MyTimerViewModel(view: self)
        
        stackView.addArrangedSubview(txtMinutes)
        stackView.addArrangedSubview(lbSeparator)
        stackView.addArrangedSubview(txtSeconds)
        
        self.view.addSubview(lbTime)
        self.view.addSubview(stackView)
        self.view.addSubview(btnCancel)
        self.view.addSubview(btnStart)
    }
    
    func buildConstraints(){
        NSLayoutConstraint.activate([
            lbTime.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            lbTime.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -80.0),
            
            txtMinutes.widthAnchor.constraint(equalToConstant: 80.0),
            lbSeparator.widthAnchor.constraint(equalToConstant: lbSeparator.intrinsicContentSize.width),
            txtSeconds.widthAnchor.constraint(equalToConstant: 80.0),
            
            stackView.heightAnchor.constraint(equalToConstant: 60.0),
            stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            btnCancel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 80.0),
            btnCancel.widthAnchor.constraint(equalToConstant: 200.0),
            btnCancel.heightAnchor.constraint(equalToConstant: 50.0),
            btnCancel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            btnStart.topAnchor.constraint(equalTo: btnCancel.bottomAnchor, constant: 30.0),
            btnStart.widthAnchor.constraint(equalToConstant: 200.0),
            btnStart.heightAnchor.constraint(equalToConstant: 50.0),
            btnStart.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc func btnStartPressed(_ sender: UIButton){
        
        guard let auxMinutes = txtMinutes.text else {return}
        guard let auxSeconds = txtSeconds.text else {return}
        
        let minutes = auxMinutes.isEmpty ? "00" : auxMinutes
        let seconds = auxSeconds.isEmpty ? "00" : auxSeconds
        
        lbTime.text = "\(minutes) : \(seconds)"
        configComponents(timerIsStarted: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.viewModel?.sendInitialTime(minutes: minutes, seconds: seconds)
        }
    }
    
    @objc func btnCancelPressed(_ sender: UIButton){
        configComponents(timerIsStarted: false)
        viewModel?.finishTimer()
    }
    
    func configComponents(timerIsStarted: Bool){
        lbTime.isHidden     = !timerIsStarted
        btnCancel.isHidden  = !timerIsStarted
        btnStart.isHidden   = timerIsStarted
        
        if timerIsStarted == false{
            txtSeconds.text = ""
            txtMinutes.text = ""
        }
    }
}

extension MyTimerView: MyTimerViewModelProtocol{
    
    func showTime(_ time: String) {
        print("Tiempo: \(time)")
        DispatchQueue.main.async {
            self.lbTime.text = time
        }
    }
    
    func resetComponents() {
        DispatchQueue.main.async {
            self.configComponents(timerIsStarted: false)
        }
    }
}
