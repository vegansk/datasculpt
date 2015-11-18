import unittest, fp/option
import datasculpt/dsl, datasculpt/model

let r = newRepository()

defStruct r, TestData:
  x: int
  `type`: string
  ## `x` is `x`
  z1: option[int]
  z2: option[seq[int]]

suite "DSL":

  test "Basic":
    echo r
