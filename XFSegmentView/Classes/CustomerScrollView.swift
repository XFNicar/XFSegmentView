

import UIKit

open class CustomerScrollView: UIScrollView,UIGestureRecognizerDelegate {

    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.view!.isKind(of: NSClassFromString("UILayoutContainerView")!) {
            if self.contentOffset.x == 0 {
                return true
            }
        }
        return false
    }


}
