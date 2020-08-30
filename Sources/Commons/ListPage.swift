import Foundation

struct ListPage<T> {
    let items: [T]
    let currentPage: UInt
    let hasNext: Bool

    init(items: [T], page: UInt, hasNext: Bool) {
        self.items = items
        self.currentPage = page
        self.hasNext = hasNext
    }

    static func first(items: [T], hasNext: Bool) -> ListPage<T> {
        return ListPage<T>(items: items, page: 1, hasNext: hasNext)
    }

    static func unInitialized<U>() -> ListPage<U> {
        return ListPage<U>(items: [], page: 0, hasNext: false)
    }

    static func empty() -> ListPage<T> {
        return ListPage<T>(items: [], page: 0, hasNext: false)
    }

    func with(nextPage: ListPage<T>) -> ListPage<T> {
        return ListPage(
            items: self.items + nextPage.items,
            page: self.currentPage + 1,
            hasNext: nextPage.hasNext
        )
    }
}
