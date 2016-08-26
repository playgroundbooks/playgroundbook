import UIKit

var str = "Hello, playground"

func sharedFunc() {
  print("This should be accessible to all pages.")
}

//// Page 1.

str = "Yo, it's page 1."
sharedFunc()

//// Page 2.

sharedFunc()
str = "Page 2 awww yeah."
