import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
  [
    testCase(ChineseAstrologyCalendarTests.allTests),
  ]
}
#endif
