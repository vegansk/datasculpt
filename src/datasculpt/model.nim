import sequtils

type
  TypeKind* = enum
    tkSimple,
    tkComposite
  Type* = ref object
    name*: string
    case kind*: TypeKind
    of tkSimple:
      discard
    of tkComposite:
      param*: Type
  Field* = ref object
    name*: string
    `type`*: Type
  Fields* = seq[Field]
  Struct* = ref object
    name*: string
    fields*: Fields

####################################################################################################
# Type

proc simpleType*(name: string): Type =
  ## Creates simple type
  Type(name: name, kind: tkSimple)

proc complexType*(name: string, param: Type): Type =
  ## Creates complex type
  Type(name: name, kind: tkComposite, param: param)

proc `==`*(x,  y: Type): bool =
  if x.name != y.name:
     false
  elif x.kind == y.kind and x.kind == tkComposite:
    x.param == y.param
  else:
    x.kind == y.kind

proc `$`*(t: Type): string =
  case t.kind
  of tkSimple:
    t.name
  of tkComposite:
    t.name & "[" & $t.param & "]"

####################################################################################################
# Field

proc field*(name: string, `type`: Type): Field =
  ## Creates field with `name` and `type`
  Field(name: name, `type`: `type`)

proc `==`*(x, y: Field): bool =
  x.name == y.name and x.`type` == y.`type`

proc `$`*(f: Field): string =
  f.name & ": " & $f.`type`

####################################################################################################
# Fields

# TODO: Wait for the issue https://github.com/nim-lang/Nim/issues/3549 to resolve
# proc `$`(f: Fields): string =
#   let m: seq[string] = mapIt(f, $(it.Field))
#   m.foldl(a & ", " & b)

proc `$`(f: Fields): string =
  case f.len
  of 0: ""
  else:
    var r = $f[0]
    for v in f[1..high(f)]:
      r = r & ", " & $v
    r

####################################################################################################
# Struct

proc struct*(name: string, fields: Fields): Struct =
  Struct(name: name, fields: fields)

proc `==`*(x, y: Struct): bool =
  x.name == y.name and x.fields == y.fields

proc `$`*(s: Struct): string =
  s.name & "(" & $(s.fields) & ")"
  