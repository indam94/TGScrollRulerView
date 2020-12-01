//
//  TGScrollRulerViewCell.swift
//  TGScrollRulerView
//
//  Created by DONGGUN LEE on 2020/11/30.
//

import UIKit

class TGScrollRulerViewCell: UICollectionViewCell{
    var value: Int = 0{
        didSet{
            setupValue()
        }
    }
    var cellHeight: CGFloat = 80
    var cellWidth: CGFloat = 2
    
    let colorView: UIView = {
        let aView = UIView()
        aView.translatesAutoresizingMaskIntoConstraints = false
        return aView
    }()
    let valueLabel: UILabel = {
        let aLabel = UILabel()
        aLabel.isHidden = true
        aLabel.textColor = .darkGray
        aLabel.font = .systemFont(ofSize: 17, weight: .bold)
        aLabel.translatesAutoresizingMaskIntoConstraints = false
        return aLabel
    }()
    
    //MARK: - Method
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        
        setupContentView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        valueLabel.isHidden = true
        valueLabel.textColor = .darkGray
    }
    
    private func setupContentView(){
        contentView.addSubview(colorView)
        contentView.addSubview(valueLabel)
        setupLayout()
    }
    
    private func setupLayout(){
        NSLayoutConstraint.activate([
            valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            valueLabel.topAnchor.constraint(equalTo: topAnchor),
            valueLabel.heightAnchor.constraint(equalToConstant: 20),
            
            colorView.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 10),
            colorView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            colorView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            colorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            colorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            colorView.widthAnchor.constraint(equalToConstant: cellWidth),
            colorView.heightAnchor.constraint(equalToConstant: cellHeight - 30),
        ])
        
    }
    
    private func setupValue(){

        valueLabel.text = "\(value)"
    }
}
