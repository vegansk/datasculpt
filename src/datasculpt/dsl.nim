import macros

# This is an example of our DSL:
dumpTree:
  defType BaseObject(inheritable, immutable):
    strField: string; notEmpty(); minLen(5); maxLen(100); desc("This is a string field")
    strAnotherField:
      string
      dbField:
        notNull
        maxLen(200)
    optionField: Option[string]
        .desc("One more field")
        .notEmpty() 
        .minLen(5)
        .maxLen(100)
