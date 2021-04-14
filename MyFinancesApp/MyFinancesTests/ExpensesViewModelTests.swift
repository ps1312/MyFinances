//
//  ExpensesViewModelTests.swift
//  MyFinancesTests
//
//  Created by Paulo Sergio da Silva Rodrigues on 13/04/21.
//

import XCTest
import MyFinances

class ExpensesViewModel {
    typealias Observer<T> = ((T) -> Void)

    private let loader: ExpensesLoader

    var onIsLoadingChange: Observer<Bool>?
    var onExpensesLoad: Observer<[ExpenseItem]>?

    init(loader: ExpensesLoader) {
        self.loader = loader
    }

    func loadExpenses() {
        onIsLoadingChange?(true)

        loader.load { [weak self] result in
            if let items = try? result.get() {
                self?.onExpensesLoad?(items)
            }

            self?.onIsLoadingChange?(false)
        }
    }

}

class ExpensesViewModelTests: XCTestCase {
    func test_loadExpenses_callsExpensesLoader() {
        let (sut, loaderSpy) = makeSUT()

        sut.loadExpenses()

        XCTAssertEqual(loaderSpy.callsCount, 1)
    }

    func test_loadExpenses_executeCallbacksCorrectlyInOrder() {
        var messages = [Messages]()
        let (sut, loaderSpy) = makeSUT()

        sut.onIsLoadingChange = { isLoading in
            messages.append(.onIsLoadingChange(isLoading))
        }

        sut.onExpensesLoad = { expenses in
            messages.append(.onExpensesLoad(expenses))
        }

        sut.loadExpenses()

        loaderSpy.completeWith(expenses: [])

        XCTAssertEqual(messages, [
            .onIsLoadingChange(true),
            .onExpensesLoad([]),
            .onIsLoadingChange(false)
        ])
    }

    func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: ExpensesViewModel, loaderSpy: LoaderSpy) {
        let loaderSpy = LoaderSpy()
        let sut = ExpensesViewModel(loader: loaderSpy)

        testMemoryLeak(loaderSpy, file: file, line: line)
        testMemoryLeak(sut, file: file, line: line)

        return (sut, loaderSpy)
    }

    enum Messages: Equatable {
        case onIsLoadingChange(_ isLoading: Bool)
        case onExpensesLoad(_ expenses: [ExpenseItem])
    }

    class LoaderSpy: ExpensesLoader {
        var completions = [(LoadExpensesResult) -> Void]()
        var callsCount: Int = 0

        func load(completion: @escaping (LoadExpensesResult) -> Void) {
            callsCount += 1
            completions.append(completion)
        }

        func completeWith(expenses: [ExpenseItem]) {
            completions[0](.success(expenses))
        }
    }
}
