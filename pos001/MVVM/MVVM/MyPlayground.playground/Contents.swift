import UIKit
import RxSwift

_ = Observable.from([1,2,3,4,5])
// .just는 단일 변수
let observable1 = Observable.just(1)
let observable2 = Observable.of([1,3,4])
// of는 배열 전체를, from은 요소 하나하나를 리턴
let observable3 = Observable.from([1,2,3,4,5])

observable3.subscribe{(event) in
    print(event)
}

let disposeBag = DisposeBag()
//
Observable.of("A", "B", "C")
    .subscribe {
        print($0)
    }.disposed(by: disposeBag)

let subject = PublishSubject<String>()
subject.onNext("'Issue #1")
subject.subscribe{ (event) in
    print(event)
}
subject.onNext("Issue #2")
subject.onNext("Issue #3")
subject.dispose()
subject.onCompleted()
