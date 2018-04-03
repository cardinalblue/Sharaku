//
//  SHColorControlsCollectionView.swift
//  Pods-Sharaku_Example
//
//  Created by yyjim on 02/04/2018.
//

import UIKit
import Foundation

enum CIColorControl: String {
    case contrast
    case brightness
    case saturation
    case alpha
    
    var filterName: String {
        switch self {
        case .contrast:
            return "inputContrast"
        case .brightness:
            return "inputBrightness"
        case .saturation:
            return "inputSaturation"
        case .alpha:
            return "inputAVector"
        }
    }
}

internal class ControlValue {
    
    var control: CIColorControl
    var min: Float
    var max: Float
    var value: Float
    
    init(control: CIColorControl, min: Float, max: Float, value: Float) {
        self.control = control
        self.min     = min
        self.max     = max
        self.value   = value
    }
}

class ControlCollectionCell: UICollectionViewCell
{
    var controlValue: ControlValue? = nil {
        didSet {
            update()
        }
    }
    
    var onValueChange: ((ControlValue) -> Void)? = nil
    
    private let slider = UISlider()
    private let label  = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.textAlignment = .right
        
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(handleValueChange(_:)), for: .valueChanged)
        
        contentView.addSubview(slider)
        contentView.addSubview(label)
        
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        slider.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 10).isActive = true
        slider.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
            
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleValueChange(_ sender: UISlider) {
        guard let controlValue = controlValue else {
            return
        }
        controlValue.value = sender.value
        onValueChange?(controlValue)
    }
    
    private func update() {
        guard let controlValue = controlValue else {
            label.text = nil
            slider.isEnabled = true
            return
        }
        
        label.text = controlValue.control.rawValue
        label.font = UIFont.systemFont(ofSize: 14)

        slider.isEnabled = true
        slider.minimumValue = controlValue.min
        slider.maximumValue = controlValue.max
        slider.value = controlValue.value
    }
}

// =============================================================================

class ControlsCollectionView: UICollectionView {
    
    private let cellIdentifier = "controlValueCell"
    
    var onValueChange: ((ControlValue) -> Void)? = nil
    
    var controls: [ControlValue] = [] {
        didSet {
            reloadData()
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        register(ControlCollectionCell.self, forCellWithReuseIdentifier: cellIdentifier)
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ControlsCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ControlCollectionCell
        cell.controlValue = controls[indexPath.item]
        cell.onValueChange = onValueChange
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controls.count
    }
    
}
