//
//  CellModelDataSource.swift
//  Zdravel
//
//  Created by Matěj Jirásek on 08/02/2017.
//  Copyright © 2017 The Funtasty s.r.o. All rights reserved.
//

import UIKit

open class CellModelDataSource: NSObject {
    var cells: [CellModel]

    init(cells: [CellModel]) {
        self.cells = cells
    }
}

extension CellModelDataSource: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(convertible: cells[indexPath.row])
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }

    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return cells[indexPath.row].highlighting
    }
}

extension CellModelDataSource: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cells[indexPath.row].cellHeight
    }
}
