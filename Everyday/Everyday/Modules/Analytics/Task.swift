import Foundation

struct GridCell: Identifiable, Codable {
    var id = UUID()
    var name: String
    var chartType: ChartType
    var barUnit: BarUnit
}

enum Priority: Int {
    case high   = 0
    case medium = 1
    case low    = 2
    case none   = 3
}

enum ChartType: String, CaseIterable, Identifiable, Codable {
    case bar = "Столбцы"
    case line = "Линия"
    var id: String {
        self.rawValue
    }
}

enum BarUnit: String, CaseIterable, Identifiable, Codable {
    case day = "День"
    case week = "Неделя"
    case month = "Месяц"
    var id: String {
        self.rawValue
    }
}

struct TaskData: Codable, Identifiable, Hashable {
    var id = UUID()
    var date: Date
    var priority: [Int]
    var animate: Bool = false
}
