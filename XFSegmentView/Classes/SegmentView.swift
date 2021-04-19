
import UIKit

@objc protocol SegmentViewDataSource: class {
    /// 返回当前index位置pageView
    @objc func segmentView(segmentView: SegmentView, subViewWith index: Int) -> UIView
    /// 返回当前index位置标题
//    @objc optional func segmentView(segmentView: SegmentView, barTitle withindex: Int) -> String?
    /// 返回segmentBar的全部标题
    @objc func subTitleWithPages(segmentView: SegmentView) -> [String]
    
    
    @objc optional func segmentView(segmentView: SegmentView, barWidthForIndex: Int) -> CGFloat
    
    
}

@objc protocol SegmentViewDelegate: class {
    @objc optional func segmentView(segmentView: SegmentView, didEndScroll atIndex: Int)
}



class SegmentView: UIView,UICollectionViewDelegate {

    weak var dataSource: SegmentViewDataSource?
    weak var delegate: SegmentViewDelegate?
    var myScrollView: CustomerScrollView!
    var segmentBar: SegmentBar!
    var subPageViews: [UIView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        segmentBar.barItems = (dataSource?.subTitleWithPages(segmentView: self))!
        segmentBar.barCollectionView.reloadData()
        myScrollView.contentSize = CGSize(width: CGFloat(segmentBar.barItems.count) * frame.width, height: frame.height - segmentBar.barHeight)
        
        for index in 0...(segmentBar.barItems.count-1) {
            let itemView = dataSource?.segmentView(segmentView: self, subViewWith: index)
            itemView?.frame =  CGRect(x: CGFloat(index) * frame.width , y: 0, width: frame.width, height: frame.height - segmentBar.barHeight)
            myScrollView.addSubview(itemView!)
        }
        
    }
    
    func configUI()  {
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
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        myScrollView.setContentOffset(CGPoint(x: CGFloat(indexPath.row) * collectionView.frame.width, y: 0), animated: true)
        segmentBar.selectedIndex = indexPath.row
        if delegate != nil {
            delegate?.segmentView?(segmentView: self, didEndScroll: indexPath.row)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
         
        if scrollView.isEqual(myScrollView) {
            let scrollToScrollStop = !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
            if scrollToScrollStop {
                scrollViewDidEndenScroll(scrollView)
            }
        }
     }
     
     func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.isEqual(myScrollView) {
            let  scrollToScrollStop = scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
            if scrollToScrollStop {
                scrollViewDidEndenScroll(scrollView)
            }
        }
     }
    
    func scrollViewDidEndenScroll(_ scrollView: UIScrollView)  {
        if scrollView.isEqual(myScrollView) {
            let contentX = scrollView.contentOffset.x
            let index = contentX / scrollView.frame.width
            segmentBar.selectedIndex = lround(Double(index))
            if delegate != nil {
                delegate?.segmentView?(segmentView: self, didEndScroll: lround(Double(index)))
            }
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
