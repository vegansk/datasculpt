import unittest, datasculpt/model

suite "Model":

  test "Construct and compare types":
    check: simpleType"int" == Type(name: "int", kind: tkSimple)
    check: simpleType"int2" != Type(name: "int", kind: tkSimple)
    check: complexType("seq", simpleType"int") == Type(name: "seq", kind: tkComposite, param: simpleType"int")
    check: complexType("seq", simpleType"int") != Type(name: "seq", kind: tkComposite, param: simpleType"string")

  test "Construct and compare fields":
    check: field("x", simpleType"int") == Field(name: "x", `type`: simpleType"int")
    check: field("x", simpleType"int") != Field(name: "x", `type`: simpleType"string")

  test "Construct and compare structures":
    check:
      struct("TestStruct",
             @[field("x", simpleType"int"), field("y", complexType("seq", simpleType"int"))]
      ) == Type(name: "TestStruct", kind: tkStruct,
                  fields: @[field("x", simpleType"int"), field("y", complexType("seq", simpleType"int"))]
      )

  test "Model's debug output":
    let m = struct("TestStruct", @[field("x", simpleType"int"), field("y", complexType("seq", simpleType"int"))])
    echo m

  test "Repository":
    let m = struct("TestStruct", @[field("x", simpleType"int"), field("y", complexType("seq", simpleType"int"))])
    let r = newRepository()
    r.add(m)
    echo r
