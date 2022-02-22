
import UIKit

public protocol SegmentViewDataSource: class {
    
    // MARK: 返回当前index位置pageView
    /// - Returns: UIView对象
    func segmentView(segmentView: SegmentView, subViewWith index: Int) -> UIView
    
    /// 返回当前index位置标题
//    @objc optional func segmentView(segmentView: SegmentView, barTitle withindex: Int) -> String?
    
    // MARK: 返回segmentBar的全部标题
    /// - Returns
    func subTitleWithPages(segmentView: SegmentView) -> [String]
    
    // MARK: 返回segment bar的宽度
    /// - Returns: bar宽度
    func segmentView(segmentView: SegmentView, barWidthForIndex: Int) -> CGFloat
    
}



public protocol SegmentViewDelegate: class {
    
    // MARK: 当前选中第几页
    func segmentView(segmentView: SegmentView, didEndScroll atIndex: Int)
}



open class SegmentView: UIView,UICollectionViewDelegate {

    // 数据源
    open weak var dataSource: SegmentViewDataSource?
    // 代理
    open weak var delegate: SegmentViewDelegate?
    // 承载内容的scrollview
    open var myScrollView: CustomerScrollView!
    // 标题
    open var segmentBar: SegmentBar!
    // 内容
    open var subPageViews: [UIView] = []
    // 是否允许动画切换
    open var enablePageAnimation: Bool = true
    // 是否允许按页滚动
    open var isPagingEnabled: Bool {
        set {
            myScrollView.isPagingEnabled = newValue
        }
        get {
            return myScrollView.isPagingEnabled
        }
    }
    // 是否允许滚动
    open var isScrollEnabeled: Bool {
        set {
            myScrollView.isScrollEnabled = newValue
        }
        get {
            return myScrollView.isScrollEnabled
        }
    }
    
    // 构造函数
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 刷新数据
    open func reloadData() {
        segmentBar.barItems = (dataSource?.subTitleWithPages(segmentView: self))!
        segmentBar.barCollectionView.reloadData()
        myScrollView.contentSize = CGSize(width: CGFloat(segmentBar.barItems.count) * frame.width, height: frame.height - segmentBar.barHeight)
        
        for index in 0...(segmentBar.barItems.count-1) {
            let itemView = dataSource?.segmentView(segmentView: self, subViewWith: index)
            itemView?.frame =  CGRect(x: CGFloat(index) * frame.width , y: 0, width: frame.width, height: frame.height - segmentBar.barHeight)
            myScrollView.addSubview(itemView!)
        }
        
    }
    
    // MARK: 布局UI
    open func configUI()  {
        segmentBar = SegmentBar.init(frame: CGRect(x: 0, y: 0, width:frame.width, height: 50))
        segmentBar.barCollectionView?.delegate = self
        addSubview(segmentBar)
        myScrollView = CustomerScrollView.init(frame: CGRect(x: 0, y: segmentBar.barHeight, width: frame.width, height: frame.height - segmentBar.barHeight))
        myScrollView.isPagingEnabled = true
        myScrollView.showsHorizontalScrollIndicator = false
        myScrollView.bounces = false
        addSubview(myScrollView)
        myScrollView.delegate = self
    }
    
    open func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        myScrollView.setContentOffset(CGPoint(x: CGFloat(indexPath.row) * collectionView.frame.width, y: 0), animated: enablePageAnimation)
        segmentBar.selectedIndex = indexPath.row
        if delegate != nil {
            delegate?.segmentView(segmentView: self, didEndScroll: indexPath.row)
        }
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
         
        if scrollView.isEqual(myScrollView) {
            let scrollToScrollStop = !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
            if scrollToScrollStop {
                scrollViewDidEndenScroll(scrollView)
            }
        }
     }
     
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.isEqual(myScrollView) {
            let  scrollToScrollStop = scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
            if scrollToScrollStop {
                scrollViewDidEndenScroll(scrollView)
            }
        }
     }
    
    open func scrollViewDidEndenScroll(_ scrollView: UIScrollView)  {
        if scrollView.isEqual(myScrollView) {
            let contentX = scrollView.contentOffset.x
            let index = contentX / scrollView.frame.width
            segmentBar.selectedIndex = lround(Double(index))
            if delegate != nil {
                delegate?.segmentView(segmentView: self, didEndScroll: lround(Double(index)))
            }
        }
        
    }
    
    
    // MARK: 代理返回当前选中索引
    /// - Parameter scrollView: UIscrollview
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isEqual(myScrollView) {
            let contentX = scrollView.contentOffset.x
            let index = contentX / scrollView.frame.width
            let lineX = index * segmentBar.itemWidth + (segmentBar.itemWidth - segmentBar.lineWidth) / 2
            let lineY = segmentBar.frame.height - 2
            let lineW = segmentBar.lineWidth
            segmentBar.lineView.frame = CGRect(x: lineX, y: lineY, width: lineW, height: 2)
            
            if segmentBar.lineView.frame.origin.x > (scrollView.frame.width - segmentBar.lineWidth) {
                segmentBar.barCollectionView.scrollToItem(at: IndexPath.init(row: Int(index), section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
            }
        }
    }

}
