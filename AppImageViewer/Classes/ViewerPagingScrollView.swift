//
//  AppImageViewer
//
//  Created by Karthik on 1/27/18.
//

import Foundation

class ViewerPagingScrollView: UIScrollView {
    
    fileprivate let pageIndexTagOffset: Int = 1000
    fileprivate let sideMargin: CGFloat = 10
    fileprivate var visiblePages: [ViewerZoomingScrollView] = []
    fileprivate var recycledPages: [ViewerZoomingScrollView] = []
    fileprivate weak var browser: AppImageViewer?

    var numberOfPhotos: Int {
        return browser?.photos.count ?? 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, browser: AppImageViewer) {
        self.init(frame: frame)
        self.browser = browser

        isPagingEnabled = true
        showsHorizontalScrollIndicator = true
        showsVerticalScrollIndicator = true

        updateFrame(bounds, currentPageIndex: browser.currentPageIndex)
    }
    
    func reload() {
        visiblePages.forEach({$0.removeFromSuperview()})
        visiblePages.removeAll()
        recycledPages.removeAll()
    }

    func jumpToPageAtIndex(_ frame: CGRect) {
        let point = CGPoint(x: frame.origin.x - sideMargin, y: 0)
        setContentOffset(point, animated: true)
    }
    
    func updateFrame(_ bounds: CGRect, currentPageIndex: Int) {
        var frame = bounds
        frame.origin.x -= sideMargin
        frame.size.width += (2 * sideMargin)
        
        self.frame = frame
        
        if visiblePages.count > 0 {
            for page in visiblePages {
                let pageIndex = page.tag - pageIndexTagOffset
                page.frame = frameForPageAtIndex(pageIndex)
                page.setMaxMinZoomScalesForCurrentBounds()
            }
        }
        
        updateContentSize()
        updateContentOffset(currentPageIndex)
    }
    
    func updateContentSize() {
        contentSize = CGSize(width: bounds.size.width * CGFloat(numberOfPhotos), height: bounds.size.height)
    }
    
    func updateContentOffset(_ index: Int) {
        let pageWidth = bounds.size.width
        let newOffset = CGFloat(index) * pageWidth
        contentOffset = CGPoint(x: newOffset, y: 0)
    }
    
    func tilePages() {
        
        guard let browser = browser else {
            return            
        }
        
        let firstIndex: Int = getFirstIndex()
        let lastIndex: Int = getLastIndex()
        
        visiblePages
            .filter({ $0.tag - pageIndexTagOffset < firstIndex })
            .filter({ $0.tag - pageIndexTagOffset > lastIndex })
            .forEach { page in
                recycledPages.append(page)
                page.prepareForReuse()
                page.removeFromSuperview()
            }
        
        let visibleSet: Set<ViewerZoomingScrollView> = Set(visiblePages)
        let visibleSetWithoutRecycled: Set<ViewerZoomingScrollView> = visibleSet.subtracting(recycledPages)
        visiblePages = Array(visibleSetWithoutRecycled)
        
        while recycledPages.count > 2 {
            recycledPages.removeFirst()
        }
        
        for index: Int in firstIndex...lastIndex {
            if visiblePages.filter({ $0.tag - pageIndexTagOffset == index }).count > 0 {
                continue
            }
            
            let page: ViewerZoomingScrollView = ViewerZoomingScrollView(frame: frame, browser: browser)
            page.frame = frameForPageAtIndex(index)
            page.tag = index + pageIndexTagOffset
            page.photo = browser.photos[index]
            
            visiblePages.append(page)
            addSubview(page)
        }
    }
    
    func pageDisplayedAtIndex(_ index: Int) -> ViewerZoomingScrollView? {
        for page in visiblePages where page.tag - pageIndexTagOffset == index {
            return page
        }
        return nil
    }
    
    func pageDisplayingAtPhoto(_ photo: ViewerImageProtocol) -> ViewerZoomingScrollView? {
        for page in visiblePages where page.photo === photo {
            return page
        }
        return nil
    }        
}

private extension ViewerPagingScrollView {
    
    func frameForPageAtIndex(_ index: Int) -> CGRect {
        var pageFrame = bounds
        pageFrame.size.width -= (2 * sideMargin)
        pageFrame.origin.x = (bounds.size.width * CGFloat(index)) + sideMargin
        return pageFrame
    }
    
    func getFirstIndex() -> Int {
        let firstIndex = Int(floor((bounds.minX + sideMargin * 2) / bounds.width))
        if firstIndex < 0 {
            return 0
        }
        if firstIndex > numberOfPhotos - 1 {
            return numberOfPhotos - 1
        }
        return firstIndex
    }
    
    func getLastIndex() -> Int {
        let lastIndex  = Int(floor((bounds.maxX - sideMargin * 2 - 1) / bounds.width))
        if lastIndex < 0 {
            return 0
        }
        if lastIndex > numberOfPhotos - 1 {
            return numberOfPhotos - 1
        }
        return lastIndex
    }
}

