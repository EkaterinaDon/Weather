//
//  WeekDayPicker.swift
//  Weather
//
//  Created by Ekaterina Donskaya on 07/08/2020.
//  Copyright © 2020 Ekaterina Donskaya. All rights reserved.
//

import UIKit

enum Day: Int {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    
    static let allDays: [Day] = [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
    
    var title: String {
        switch self {
        case .monday:
            return "ПН"
        case .tuesday:
            return "ВТ"
        case .wednesday:
            return "СР"
        case .thursday:
            return "ЧТ"
        case .friday:
            return "ПТ"
        case .saturday:
            return "СБ"
        case .sunday:
            return "ВС"
            
        }
    }
    
}

@IBDesignable class WeekDayPicker: UIControl {
    
    var selectedDay: Day? = nil {
        didSet {
            self.updateSelectedDay()
            self.sendActions(for: .valueChanged)
        }
    }
    
    private var buttons: [UIButton] = []
    private var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    //метод, создает стеквью и кнопки
    
    private func setupView() {
        for day in Day.allDays {
            let button = UIButton(type: .system)
            button.setTitle(day.title, for: .normal)
            button.setTitleColor(.lightGray, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.addTarget(self, action: #selector(selectDay(_:)), for: .touchUpInside)
            self.buttons.append(button)
        }
        
        
        stackView = UIStackView(arrangedSubviews: self.buttons)
        
        self.addSubview(stackView)
        
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
    }
    
    //обновляем интерфейс в зависимости от выбранной кнопки
    private func updateSelectedDay() {
        for (index, button) in self.buttons.enumerated() {
            guard let day = Day(rawValue: index) else { continue }
            button.isSelected = day == self.selectedDay
            
        }
    }
    
    //метод обработки нажатия на кнопки
    @objc private func selectDay(_ sender: UIButton) {
        //получаем индекс который является номером дня
        guard let index = self.buttons.firstIndex(of: sender) else { return } //в методичке index вместо firstIndex
        //получаем день
        guard let day = Day(rawValue: index) else { return }
        self.selectedDay = day
    }
    
    //меняем frame в лэйаутСабвбю вместо установки констрейнтов
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    
}
