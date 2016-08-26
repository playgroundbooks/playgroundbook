import UIKit

public var str = "Hello, playground"

public func sharedFunc() {
  print("This should be accessible to all pages.")
}

//// Page 1.
import UIKit

str = "Yo, it's page 1."
sharedFunc()

//// Page 2.
import UIKit

sharedFunc()
str = "Page 2 awww yeah."
