

import UIKit

open class SegmentBarItem: UICollectionViewCell {

    open var titleLabel: UILabel!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel = UILabel.init()
        titleLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        addSubview(titleLabel)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
