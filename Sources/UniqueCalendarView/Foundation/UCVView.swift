//
//  UCVView.swift
//  UniqueCalendarView
//
//  Created by Macsed on 2020/7/14.
//  Copyright © 2020 Macsed. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

internal class UCVView: UIView {
    
    private var config : UCVConfig!
    
    private var headLayer : UIView!
    private var bottomLayer : UIView!
    private var mainView : UIView!
    var backBtn : UIButton!
    private var topLabel : UILabel!
    var titleDate : Date?{
        didSet{
            topLabel.text = titleDate?.CNtoString
        }
    }
    var confirmBtn : UIButton!
    var calendar : UCVTableWithoutExtraLine!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        getBasicView()
    }
    
    convenience init(with config:UCVConfig?){
        self.init()
        if (config != nil){
            self.config = config
        }else{
            self.config = UCVConfig()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getBasicView(){
        self.backgroundColor = .clear
        getMainView()
        getBottom()
        getHead()
    }
    
    func getMainView(){
        mainView = UIView()
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = 20.reSized
        self.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(198.reSized)
            make.width.equalTo(380.reSized)
            make.height.equalTo(563.reSized)
        }
        
    }
    
    func getHead(){
        headLayer = UIView()
        headLayer.backgroundColor = config.backgroundColor
        headLayer.layer.shadowColor = getColor(hexValue: 0xE5EAF6, alpha: 0.54).cgColor
        headLayer.layer.shadowOffset = CGSize(width: 0, height: 13.25)
        headLayer.layer.shadowOpacity = 1
        headLayer.layer.shadowRadius = 13.25
        
        mainView.addSubview(headLayer)
        headLayer.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalToSuperview().dividedBy(563/91)
        }
        
        backBtn = UIButton(type: .system)
        backBtn.setImage(UIImage.init(named: "backBtn")?.reSetSize(Size: CGSize(width: 9.reSized, height: 14.reSized)).withRenderingMode(.alwaysOriginal), for: .normal)
        
        headLayer.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(29.reSized)
            make.top.equalToSuperview().offset(21.reSized)
            make.width.equalTo(9)
            make.height.equalTo(14)
        }
        
        topLabel = UILabel()
        topLabel.font = UIFont(name: "PingFangSC-Semibold", size: 22.reSized)
        topLabel.textColor = config.headerColor
        topLabel.textAlignment = .center
        topLabel.text = Date().CNtoString
        headLayer.addSubview(topLabel)
        
        topLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(12.reSized)
            make.height.equalTo(31.reSized)
        }
        
        for i in 0...6{
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = config.weekdayColor
            label.font = UIFont(name: "PingFangSC-Regular", size: 14.reSized)
            label.text = UCVCalendarWeekDays[i]
            
            headLayer.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.leading.equalToSuperview().offset((i*380/7).reSized)
                make.top.equalToSuperview().offset(62.reSized)
                make.height.equalTo(20.reSized)
                make.width.equalTo((380/7).reSized)
            }
            
        }
        
    }
    
    func getBottom(){
        
        bottomLayer = UIView()
        bottomLayer.backgroundColor = config.backgroundColor
        mainView.addSubview(bottomLayer)
        bottomLayer.snp.makeConstraints{ (make) in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(91.reSized)
        }
        
        confirmBtn = UIButton(type: .system)
        confirmBtn.layer.cornerRadius = (49/2).reSized
        confirmBtn.backgroundColor = config.confirmButtonBgColor
        confirmBtn.setTitle(config.confirmButtonLabelString, for: .normal)
        confirmBtn.titleLabel?.textAlignment = .center
        confirmBtn.titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 20.reSized)
        confirmBtn.setTitleColor(config.confirmButtonLabelColor, for: .normal)
        
        bottomLayer.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12.reSized)
            make.width.equalTo(287.reSized)
            make.height.equalTo(49.reSized)
        }
        
        calendar = UCVTableWithoutExtraLine()
        calendar.showsHorizontalScrollIndicator = false
        calendar.showsVerticalScrollIndicator = false
        calendar.separatorStyle = .none
        calendar.allowsSelection = false
        bottomLayer.addSubview(calendar)
        calendar.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(confirmBtn.snp.top).offset(-26.reSized)
        }
        
        
    }
    
    
}

