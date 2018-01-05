//
//  Variable+Additions.swift
//  DatePatternTextField
//
//  Created by Jad  on 05/01/2018.
//  Copyright © 2018 Jad . All rights reserved.
//

import Foundation
import RxSwift


public extension Variable {
	
	public func twoWayBind<O: ObserverType & ObservableType>(with observer: O) -> RxSwift.Disposable where O.E == E {
		
		let disposable1 = self
			.asObservable()
			.bind(to: observer)
		
		let disposable2 = observer
			.bind(to: self)
		
		return CompositeDisposable(disposable1, disposable2)
	}
}
