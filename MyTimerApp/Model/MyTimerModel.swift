//
//  MyTimerModel.swift
//  MyTimerApp
//
//  Created by Gustavo Tellez on 15/03/22.
//

import Foundation

protocol MyTimerModelProtocol: AnyObject{
    func sendCurrentTime(_ value: Int)
    func timerFinished()
}

class MyTimerModel{
    
    private var timer: DispatchSourceTimer?
    private weak var viewModel: MyTimerModelProtocol?
    
    public init(viewModel: MyTimerModelProtocol){
        self.viewModel = viewModel
    }
    
    func startTimer(initialTime: Int){
        
        self.cancelTimer()
        timer = DispatchSource.makeTimerSource()
        var currentTime = initialTime
        
        timer?.schedule(deadline: .now(), repeating: .seconds(1), leeway: .milliseconds(100))
        timer?.setEventHandler(handler: { [weak self] in
            
            guard let self = self else {return}
            
            currentTime = self.updateTime(currentTime)
            self.viewModel?.sendCurrentTime(currentTime)
            
            if currentTime == 0{
                self.cancelTimer()
                self.viewModel?.timerFinished()
            }
        })
        
        timer?.resume()
    }
    
    func cancelTimer(){
        timer?.cancel()
        timer = nil
    }
    
    private func updateTime(_ value: Int) -> Int{
        return value - 1
    }
}
