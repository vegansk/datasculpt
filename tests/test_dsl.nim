import unittest
import datasculpt/dsl

defStruct TestData:
  x: int
  y: string
  z: option[seq[int]]

suite "DSL":

  test "Basic":
    discard
