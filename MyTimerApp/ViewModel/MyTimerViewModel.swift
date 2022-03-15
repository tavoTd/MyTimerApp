//
//  MyTimerViewModel.swift
//  MyTimerApp
//
//  Created by Gustavo Tellez on 15/03/22.
//

import Foundation

protocol MyTimerViewModelProtocol: AnyObject{
    func showTime(_ time: String)
    func resetComponents()
}

class MyTimerViewModel{
    
    private var model: MyTimerModel?
    private weak var view: MyTimerViewModelProtocol?
    
    public init(view: MyTimerViewModelProtocol){
        model = MyTimerModel(viewModel: self)
        self.view = view
    }
    
    func sendInitialTime(minutes minutesString: String, seconds secondsString: String){
        var minutes: Int = 0
        
        if let aux = Int(minutesString){
            minutes += aux * 60
        }
        
        if let aux = Int(secondsString){
            minutes += aux
        }
        
        model?.startTimer(initialTime: minutes)
    }
    
    func finishTimer(){
        model?.cancelTimer()
    }
}

extension MyTimerViewModel: MyTimerModelProtocol{
    
    func sendCurrentTime(_ value: Int) {
        let minutes = value / 60
        let seconds = value % 60
        
        view?.showTime("\(minutes) : \(seconds)")
    }
    
    func timerFinished() {
        view?.resetComponents()
    }
}
