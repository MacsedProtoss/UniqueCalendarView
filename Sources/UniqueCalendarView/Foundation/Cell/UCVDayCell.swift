//
//  UCVDayCell.swift
//  UniqueCalendarView
//
//  Created by Macsed on 2020/7/14.
//  Copyright © 2020 Macsed. All rights reserved.
//

import UIKit
import SnapKit

internal class UCVDayCell : UICollectionViewCell{
    
    var day : Int = 0
    var month : Int = 0
    var year : Int = 0
    var config : UCVConfig!
    private var label : UILabel!
    private var chooseLayer : UIView!
    
    var singleChoose : Bool = false{
        didSet{
            chooseLayer.isHidden = !singleChoose
        }
    }
    
    func handleMutilChooseUI(forStatus status : Bool,isHead : Bool,isTail : Bool ){
        if status == false{
            self.backgroundColor = .clear
            self.setCorner(byRoundingCorners: [], withBounds: CGRect(x: 0, y: 0, width: UCVDayCellCache.base, height: UCVDayCellCache.reSized40), radius: UCVDayCellCache.reSized20)
        }else{
            self.backgroundColor = config.dayMultiSelectedBgColor
            if isHead && !isTail{
                self.setCorner(byRoundingCorners: [.topLeft,.bottomLeft], withBounds: CGRect(x: 0, y: 0, width: UCVDayCellCache.base, height: UCVDayCellCache.reSized40), radius: UCVDayCellCache.reSized20)
            }else if isTail && !isHead {
                self.setCorner(byRoundingCorners: [.topRight,.bottomRight], withBounds: CGRect(x: 0, y: 0, width: UCVDayCellCache.base, height: UCVDayCellCache.reSized40), radius: UCVDayCellCache.reSized20)
            }else if !isHead && !isTail{
                self.setCorner(byRoundingCorners: [], withBounds: CGRect(x: 0, y: 0, width: UCVDayCellCache.base, height: UCVDayCellCache.reSized40), radius: UCVDayCellCache.reSized20)
            }else{
                self.setCorner(byRoundingCorners: [.topLeft,.topRight,.bottomLeft,.bottomRight], withBounds: CGRect(x: 0, y: 0, width: UCVDayCellCache.base, height: UCVDayCellCache.reSized40), radius: UCVDayCellCache.reSized20)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(day : Int){
        self.init()
        self.day = day
        self.config = config
        getView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getView(){
        
        if day > 0{
            
            chooseLayer = UIView()
            chooseLayer.backgroundColor = .clear
            chooseLayer.layer.cornerRadius = UCVDayCellCache.reSized20
            chooseLayer.layer.borderColor = config.daySingleSelectedBgColor.cgColor
            chooseLayer.layer.borderWidth = 2.reSized
            self.addSubview(chooseLayer)
            chooseLayer.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.height.width.equalTo(UCVDayCellCache.reSized40)
            }
            chooseLayer.isHidden = true
            
            label = UILabel()
            label.text = String(describing: day)
            label.textAlignment = .center
            label.backgroundColor = .clear
            label.font = UIFont(name: "PingFangSC-Medium", size: 22.reSized)
            label.textColor = config.dayLabelColor
            self.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.width.height.equalToSuperview()
            }
            
        }
        
    }
}

