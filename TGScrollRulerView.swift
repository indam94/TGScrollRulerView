//
//  TGScrollRulerView.swift
//  TGScrollRulerView
//
//  Created by DONGGUN LEE on 2020/11/30.
//

import UIKit

public protocol TGScrollRulerDelegate: class{
    func scrollRuler(value: Int)
}

open class TGScrollRulerView: UIView{
    
    var focusIndex = 0{
        didSet(oldValue){
            if focusIndex == oldValue{return}
            resetCellColor(index: oldValue)
        }
        willSet(newValue){
            updateCellColor(index: newValue)
        }
    }
    //MARK: UI
    public var mainColor: UIColor = UIColor.blue{
        didSet{
            scrollRulerView.reloadData()
        }
    }
    public var subColor: UIColor = UIColor.lightGray{
        didSet{
            scrollRulerView.reloadData()
        }
    }
    public var subColor2: UIColor = UIColor.darkGray{
        didSet{
            scrollRulerView.reloadData()
        }
    }
    private var contentView: UIView!
    public var valueTextField: UITextField = {
        let aTextField = UITextField()
        aTextField.placeholder = "Enter Value.."
        aTextField.font = .systemFont(ofSize: 15, weight: .medium)
        aTextField.layer.cornerRadius = 10
        aTextField.borderStyle = .roundedRect
        aTextField.translatesAutoresizingMaskIntoConstraints = false
        return aTextField
    }()
    private var scrollRulerView: UICollectionView!
    private var rulerViewHeight: CGFloat = 100{
        didSet{
            updateRulerHeight()
        }
    }
    
    //MARK: Property
    public var lineWidth: CGFloat = 4
    public var lineHeihgt: CGFloat = 80
    public var minValue: Int = 0{
        didSet{
            //updateValueArray()
        }
    }
    public var maxValue: Int = 10{
        didSet{
            updateValueArray()
        }
    }
    public var intervalValue: Int = 1{
        didSet{
            updateValueArray()
        }
    }
    public var intervalValue2: Int = 10{
        didSet{
            scrollRulerView.reloadData()
        }
    }
    private var valueArray: [Int] = []
    
    open weak var delegate: TGScrollRulerDelegate?
    
    //MARK: Initialize
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupRulerView()
        setupView()
        setupLayout()
        updateValueArray()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Layout
    open func setupRulerView(){
        let layout = UICollectionViewFlowLayout()
        let aCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        aCollectionView.backgroundColor = .clear
        aCollectionView.translatesAutoresizingMaskIntoConstraints = false
        aCollectionView.showsHorizontalScrollIndicator = false
        
        let screenSize = UIScreen.main.bounds
        
        let cellWidth = lineWidth
        let cellHeight = lineHeihgt
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        aCollectionView.contentInset = UIEdgeInsets(top: 0, left: screenSize.width/2 - cellWidth, bottom: 0, right: screenSize.width/2 - cellWidth)
        aCollectionView.register(TGScrollRulerViewCell.self, forCellWithReuseIdentifier: "TGScrollRulerViewCell")
        
        aCollectionView.delegate = self
        aCollectionView.dataSource = self
        
        scrollRulerView = aCollectionView
    }
    
    open func setupView(){
        valueTextField.delegate = self
        valueTextField.addTarget(self, action: #selector(onEditTextField(_:)), for: .editingChanged)
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contentView)
        contentView.addSubview(scrollRulerView)
        contentView.addSubview(valueTextField)
    }
    
    open func setupLayout(){
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            scrollRulerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollRulerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollRulerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            //scrollRulerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            scrollRulerView.heightAnchor.constraint(equalToConstant: rulerViewHeight),
            
            valueTextField.topAnchor.constraint(equalTo: scrollRulerView.bottomAnchor, constant: 15),
            valueTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            valueTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            valueTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
    }
    
    //MARK: Update
    open func updateRulerHeight(){
        scrollRulerView.constraints.forEach{ constraint in
            if constraint.firstAttribute == .height{
                constraint.isActive = false
                scrollRulerView.removeConstraint(constraint)
            }
        }
        
        scrollRulerView.heightAnchor.constraint(equalToConstant: rulerViewHeight).isActive = true
    }
    
    open func updateValueArray(){
        valueArray = (minValue...maxValue).map{$0}
    }
    
    private func updateCellColor(index: Int){
        let focusCell = scrollRulerView.cellForItem(at: IndexPath(row: index, section: 0)) as? TGScrollRulerViewCell
        focusCell?.colorView.backgroundColor = mainColor
        focusCell?.valueLabel.textColor = mainColor
        
        valueTextField.text = "\(valueArray[index])"
        
        delegate?.scrollRuler(value: valueArray[index])
    }
    
    private func resetCellColor(index: Int){
        
        let focusCell = scrollRulerView.cellForItem(at: IndexPath(row: index, section: 0)) as? TGScrollRulerViewCell
        
        focusCell?.valueLabel.textColor = subColor2
        let value = valueArray[index]
        if value % intervalValue2 == 0{
            focusCell?.colorView.backgroundColor = subColor2
        }
        else{
            focusCell?.colorView.backgroundColor = subColor
        }
        
    }
    
    private func updateScrollView(_ i: Int){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.scrollRulerView.scrollToItem(at: [0,i], at: .left, animated: true)
        }
    }
    
    @objc private func onEditTextField(_ sender: UITextField){
        if let inputAge = Int(sender.text ?? ""){
            for i in 0..<valueArray.count{
                if i+minValue == inputAge{
                    updateScrollView(i)
                    return
                }
            }
        }
    }
}

extension TGScrollRulerView: UICollectionViewDataSource{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return valueArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TGScrollRulerViewCell", for: indexPath) as? TGScrollRulerViewCell else{return UICollectionViewCell()}
        
        let index = valueArray[indexPath.row]
        if index % intervalValue2 == 0{
            cell.colorView.backgroundColor = subColor2
            cell.valueLabel.isHidden = false
            cell.value = index
        }
        else{
            cell.colorView.backgroundColor = subColor
        }
        
        if indexPath.row == focusIndex{
            cell.colorView.backgroundColor = mainColor
        }
        
        return cell
    }
}

extension TGScrollRulerView: UICollectionViewDelegate, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout{
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = scrollRulerView.collectionViewLayout as! UICollectionViewFlowLayout
        
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        
        targetContentOffset.pointee = offset
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let layout = scrollRulerView.collectionViewLayout as! UICollectionViewFlowLayout
        
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        let index = (scrollView.contentOffset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        
        let roundedIndex = Int(round(index))
        
        if roundedIndex < 0 || roundedIndex >= valueArray.count{return}
        
        focusIndex = roundedIndex
    }
}

extension TGScrollRulerView: UITextFieldDelegate{
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let inputAge = Int(textField.text ?? ""){
            for i in 0..<valueArray.count{
                if i+minValue == inputAge{
                    updateScrollView(i)
                    return
                }
            }
        }
    }
}
