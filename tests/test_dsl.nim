import unittest
import datasculpt/dsl

defStruct TestData:
  x: int
  y: string
  ## `x` is `x`
  z1: option[int]
  z2: option[seq[int]]

suite "DSL":

  test "Basic":
    discard