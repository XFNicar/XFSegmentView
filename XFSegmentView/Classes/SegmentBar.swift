

import UIKit

open class SegmentBar: UIView,UICollectionViewDataSource {
    
    // 承载内容的scrollview
    open weak var contentScrollView: UIScrollView?
    
    // 显示bar item的collection view
    open var barCollectionView: UICollectionView!
    
    // 全部标题
    open var items: [String] = []
    
    // 控件高度
    open var barHeight: CGFloat = 45
    
    // 页面collection view布局对象
    open var layout: SegmentBarCVLayout!
    
    // 下划线
    open var lineView: UIView = UIView()
    
    // item cell identifier
    open var cellIdentifer: String = "defaultId"
    
    // 当前选中索引
    open var currentIndex: Int = 0
    
    // 下划线宽度
    open var lineWidth: CGFloat = 40
    
    // 下划线初始Y坐标
    open var lineOrginY: CGFloat = 43
    
    // 字标题字体
    open var subTitleFont: UIFont = UIFont.systemFont(ofSize: 14)
    
    // 选中标题颜色
    open var selectedTitleColor: UIColor = .black
    
    // 未选中标题颜色
    open var deSelectedTitleColor: UIColor = .gray
    
    // 标题字体
    open var titleFont : UIFont {
        set {
            subTitleFont = newValue
            barCollectionView.reloadData()
        }
        
        get {
            return subTitleFont
        }
    }
    
    // 选中位置
    open var selectedIndex: Int {
        set {
            currentIndex = newValue
            barCollectionView.reloadData()
        }
        
        get {
            return currentIndex
        }
    }
    
    // item宽度
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
    // items标题
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
    // 全部内容显示宽度
    open var contentWidth: CGFloat {
        get {
            return itemWidth * CGFloat(items.count)
        }
    }
    
    // 构造函数
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
        if indexPath.row == selectedIndex {
            cell.titleLabel.textColor = selectedTitleColor
        } else {
            cell.titleLabel.textColor = deSelectedTitleColor
        }
        cell.titleLabel.font = subTitleFont
        return cell
    }

}
