

import UIKit

class SegmentBar: UIView,UICollectionViewDataSource {
    
    
    weak var contentScrollView: UIScrollView?
    var barCollectionView: UICollectionView!
    var items: [String] = []
    var barHeight: CGFloat = 45
    var layout: SegmentBarCVLayout!
    var lineView: UIView = UIView()
    var cellIdentifer: String = "defaultId"
    var currentIndex: Int = 0
    var lineWidth: CGFloat = 40
    var lineOrginY: CGFloat = 43
    var subTitleFont: UIFont = UIFont.systemFont(ofSize: 14)
    var selectedTitleColor: UIColor = UIColor.hexColor(0x0D5EDA)
    var deSelectedTitleColor: UIColor = UIColor.hexColor(0x646D76)
    var titleFont : UIFont {
        set {
            subTitleFont = newValue
            barCollectionView.reloadData()
        }
        
        get {
            return subTitleFont
        }
    }
    
    var selectedIndex: Int {
        set {
            currentIndex = newValue
            barCollectionView.reloadData()
        }
        
        get {
            return currentIndex
        }
    }
    var itemWidth: CGFloat {
        set {
            layout.itemWidth = newValue
            lineView.frame = CGRect(x: (newValue - lineWidth) / 2, y: lineOrginY, width: lineWidth, height: 2)
            self.barCollectionView.reloadData()
        }
        get {
            return layout.itemWidth
        }
    }
    
    var barItems: [String] {
        get {
            return items
        }
        set {
            items = newValue
            lineView.frame = CGRect(x: (itemWidth - lineWidth) / 2, y: lineOrginY, width: lineWidth, height: 2)
            self.barCollectionView.reloadData()
        }
    }
    
    var contentWidth: CGFloat {
        get {
            return itemWidth * CGFloat(items.count)
        }
    }
    
    override init(frame: CGRect) {
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
        lineView.backgroundColor = UIColor.hexColor(0x0D5EDA)
        barCollectionView.addSubview(lineView)
        barCollectionView.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifer, for: indexPath) as! SegmentBarItem
        cell.titleLabel.text = barItems[indexPath.row]
        if indexPath.row == selectedIndex {
            cell.titleLabel.textColor = selectedTitleColor
        } else {
            cell.titleLabel.textColor = deSelectedTitleColor
        }
        cell.titleLabel.font = subTitleFont
        return cell
    }

}
