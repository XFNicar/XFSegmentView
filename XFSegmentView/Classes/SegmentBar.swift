

import UIKit

open class SegmentBar: UIView,UICollectionViewDataSource {
    
    
    open weak var contentScrollView: UIScrollView?
    open var barCollectionView: UICollectionView!
    open var items: [String] = []
    open var barHeight: CGFloat = 45
    open var layout: SegmentBarCVLayout!
    open var lineView: UIView = UIView()
    open var cellIdentifer: String = "defaultId"
    open var currentIndex: Int = 0
    open var lineWidth: CGFloat = 40
    open var lineOrginY: CGFloat = 43
    open var subTitleFont: UIFont = UIFont.systemFont(ofSize: 14)
    open var selectedFont: UIFont?
    open var selectedTitleColor: UIColor = .black
    open var deSelectedTitleColor: UIColor = .gray
    open var titleFont : UIFont {
        set {
            subTitleFont = newValue
            barCollectionView.reloadData()
        }
        
        get {
            return subTitleFont
        }
    }
    
    open var selectedIndex: Int {
        set {
            currentIndex = newValue
            barCollectionView.reloadData()
        }
        
        get {
            return currentIndex
        }
    }
    open var itemWidth: CGFloat {
        set {
            layout.itemWidth = newValue
            lineView.frame = CGRect(x: (newValue - lineWidth) / 2, y: lineOrginY, width: lineWidth, height: 2)
            self.barCollectionView.reloadData()
        }
        get {
            return layout.itemWidth
        }
    }
    
    open var barItems: [String] {
        get {
            return items
        }
        set {
            items = newValue
            lineView.frame = CGRect(x: (itemWidth - lineWidth) / 2, y: lineOrginY, width: lineWidth, height: 2)
            self.barCollectionView.reloadData()
        }
    }
    
    open var contentWidth: CGFloat {
        get {
            return itemWidth * CGFloat(items.count)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        barHeight = frame.height
        lineOrginY = frame.height - 2
        layout = SegmentBarCVLayout(65, frame.height - 2)
        barCollectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), collectionViewLayout: layout)
        barCollectionView.register(SegmentBarItem.self, forCellWithReuseIdentifier: cellIdentifer)
        barCollectionView.dataSource = self
        addSubview(barCollectionView)
        backgroundColor = .clear
        barCollectionView.backgroundColor = .clear
        lineView.backgroundColor = .black
        barCollectionView.addSubview(lineView)
        barCollectionView.showsHorizontalScrollIndicator = false
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifer, for: indexPath) as! SegmentBarItem
        cell.titleLabel.text = barItems[indexPath.row]
        cell.titleLabel.font = subTitleFont
        if indexPath.row == selectedIndex {
            cell.titleLabel.textColor = selectedTitleColor
            if let font = selectedFont {
                cell.titleLabel.font = font
            }
        } else {
            cell.titleLabel.textColor = deSelectedTitleColor
        }
        
        return cell
    }

}
