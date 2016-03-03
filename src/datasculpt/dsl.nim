import macros

# This is an example of our DSL:
dumpTree:
  defType BaseObject, inheritable, immutable, inherits BaseBaseObject:
    strField string, notEmpty, minLen 5, maxLen 100, (dbField notNull, maxLen 200), desc "This is a string field"
    strAnotherField:
      string
      dbField: notNull; maxLen(200); linkedTo(AnotherObject.someField)
    optionField: Option[string]
        .desc("One more field")
        .notEmpty() 
        .minLen(5)
        .maxLen(100)

