//
//  WeatherCollectionViewLayout.swift
//  Weather
//
//  Created by Ekaterina Donskaya on 27/08/2020.
//  Copyright © 2020 Ekaterina Donskaya. All rights reserved.
//

import UIKit

class WeatherCollectionViewLayout: UICollectionViewLayout {
    //хранит атрибуты для заданных индексов
    var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    
    //кол-во столбцов
    var columnsCount = 2
    
    //высота ячейки
    var cellHeight: CGFloat = 128
    
    //суммарная высота ячеек
    private var totalCellHeight: CGFloat = 0
    
    override func prepare() {
        //инициализируем атрибуты
        self.cacheAttributes = [:]
        
        //проверяем наличие collectionView
        guard let collectionView = self.collectionView else { return }
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        //проверяем что в секуии есть хоть одна ячейка
        guard itemsCount > 0 else { return }
        
        //Затем нужно посчитать frame для каждой ячейки. Для этого добавим цикл, в котором будем создавать атрибуты для ячейки и считать frame, а также переменные lastX и lastY, которые будут хранить последние x и y для вычисления origin каждого frame:
        
        let bigCellWidth = collectionView.frame.width
        let smallCellWidth = collectionView.frame.width / CGFloat(self.columnsCount)

        var lastY: CGFloat = 0
        var lastX: CGFloat = 0
        
        for index in 0..<itemsCount {
            let indexPath = IndexPath(item: index, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
        
    
        //Теперь вычисление frame разделится на две части — для большой и для маленькой ячейки. Чтобы определить, большая ячейка или маленькая, достаточно взять остаток от деления (текущего индекса + 1) на (количество столбцов + 1). Если остаток равен 0, это большая ячейка
         let isBigCell = (index + 1) % (self.columnsCount + 1) == 0
    

        //вычисляем frame в зависимости от ячейки
        if isBigCell {
            attributes.frame = CGRect(x: 0, y: lastY, width: bigCellWidth, height: self.cellHeight)
            lastY += self.cellHeight
        } else {
            attributes.frame = CGRect(x: lastX, y: lastY, width: smallCellWidth, height: self.cellHeight)
            let isLastColumn = (index + 2) % (self.columnsCount + 1) == 0 || index == itemsCount - 1
            if isLastColumn {
                lastX = 0
                lastY += self.cellHeight
            } else {
                lastX += smallCellWidth
            }
        }
        //добавим атрибуты в словарь
    cacheAttributes[indexPath] = attributes

        //присвоим значение totalCellHeight
        self.totalCellHeight = lastY
    }
    }

    //переопределяем методы, которые возвращают атрибуты для заданных области и индекса
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cacheAttributes.values.filter { attributes in return rect.intersects(attributes.frame)
        }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cacheAttributes[indexPath]
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: self.collectionView?.frame.width ?? 0, height: self.totalCellHeight)
    }
}
