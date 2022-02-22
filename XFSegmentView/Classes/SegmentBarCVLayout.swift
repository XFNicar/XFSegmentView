

import UIKit

open class SegmentBarCVLayout: UICollectionViewLayout {
    // 布局对象数组
    private var attriArray:[UICollectionViewLayoutAttributes] = []
    // 内容范围高度
    open var contentHeight: CGFloat = 0
    // 内容范围宽度
    open var contentWidth: CGFloat = 0
    // item高度
    open var itemHeight: CGFloat = 0
    // item宽度
    open var itemWidth: CGFloat = 0
    // 构造函数
    public init(_ itemWidth: CGFloat, _ itemHeight: CGFloat) {
        super.init()
        self.itemWidth = itemWidth
        self.itemHeight = itemHeight
        self.contentHeight = itemHeight
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func prepare() {
        attriArray.removeAll()
        contentHeight = 0
        contentWidth = 0
        
        let allSection = self.collectionView?.dataSource?.numberOfSections?(in: self.collectionView!)
        for section in 0...(allSection!-1) {
            let allRow = self.collectionView?.dataSource?.collectionView(self.collectionView!, numberOfItemsInSection: section)
            guard allRow! > 0 else {
                continue
            }
            for row in 0...(allRow! - 1) {
                let indexPath = IndexPath.init(row: row, section: section)
                self.attriArray.append(self.layoutAttributesForItem(at: indexPath )!)
            }
        }
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attri = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        attri.frame = CGRect(x: itemWidth * CGFloat(indexPath.row),
                             y: 0,
                             width:  itemWidth,
                             height: itemHeight)
        contentWidth = itemWidth * CGFloat((indexPath.row + 1))
        return attri
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attriArray
    }
    
    
    open override var collectionViewContentSize: CGSize {
        get {
            return CGSize(width: contentWidth, height:contentHeight)
        }
    }
}
