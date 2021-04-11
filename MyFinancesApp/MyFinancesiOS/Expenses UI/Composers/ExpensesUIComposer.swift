//
//  ExpensesUIComposer.swift
//  MyFinancesiOS
//
//  Created by Paulo Sergio da Silva Rodrigues on 09/04/21.
//

import Foundation
import MyFinances

public final class ExpensesUIComposer {
    private init() {}

    public static func compose(loader: ExpensesLoader) -> ExpensesViewController {
        let expensesPresenter = ExpensesPresenter(loader: loader)
        let refreshController = ExpensesRefreshViewController(presenter: expensesPresenter)

        let expensesController = ExpensesViewController(refreshController: refreshController)
        expensesPresenter.loadView = refreshController
        expensesPresenter.expensesView = ExpensesViewAdapter(controller: expensesController)

        return expensesController
    }

    private static func adaptExpensesModelsToCellControllers(expensesController: ExpensesViewController) -> (([ExpenseItem]) -> Void) {
        return { [weak expensesController] items in
            expensesController?.cellControllers = items.map { model in
                let viewModel = ExpenseCellViewModel(model: model)
                return ExpenseCellViewController(viewModel: viewModel)
            }
        }
    }
}

class ExpensesViewAdapter: ExpensesView {
    private weak var controller: ExpensesViewController?

    init(controller: ExpensesViewController) {
        self.controller = controller
    }

    func display(expenses: [ExpenseItem]) {
        controller?.cellControllers = expenses.map { model in
            let viewModel = ExpenseCellViewModel(model: model)
            return ExpenseCellViewController(viewModel: viewModel)
        }
    }
}