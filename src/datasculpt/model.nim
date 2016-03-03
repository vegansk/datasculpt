import sequtils, tables, fp.option

type
  TypeKind* = enum
    tkSimple,
    tkComposite,
    tkStruct
  Type* = ref object
    name*: string
    case kind*: TypeKind
    of tkSimple:
      discard
    of tkComposite:
      param*: Type
    of tkStruct:
      fields*: Fields
  Field* = ref object
    name*: string
    desc*: Option[string]
    `type`*: Type
  Fields* = seq[Field]
  Repository* = ref Table[string, Type]

####################################################################################################
# Forward declarations

proc `==`*(x,  y: Type): bool
proc `$`*(t: Type): string

####################################################################################################
# Field

proc field*(name: string, desc: Option[string], `type`: Type): Field =
  ## Creates field with `name`, `desc` and `type`
  Field(name: name, desc: desc, `type`: `type`)

proc field*(name: string, `type`: Type): Field =
  ## Creates field with `name` and `type`
  Field(name: name, desc: "".none, `type`: `type`)

proc `==`*(x, y: Field): bool =
  x.name == y.name and x.`type` == y.`type`

proc `$`*(f: Field): string =
  f.name & ": " & $f.`type`

####################################################################################################
# Fields

proc `$`(f: Fields): string =
  let m: seq[string] = mapIt(f, $(it.Field))
  m.foldl(a & ", " & b)

####################################################################################################
# Type

proc simpleType*(name: string): Type =
  ## Creates simple type
  Type(name: name, kind: tkSimple)

proc complexType*(name: string, param: Type): Type =
  ## Creates complex type
  Type(name: name, kind: tkComposite, param: param)

proc struct*(name: string, fields: Fields): Type =
  Type(name: name, kind: tkStruct, fields: fields)

proc `==`*(x,  y: Type): bool =
  if x.kind != y.kind or x.name != y.name:
    false
  else:
    case x.kind
    of tkSimple:
      true
    of tkComposite:
      x.param == y.param
    of tkStruct:
      x.fields == y.fields

proc `$`*(t: Type): string =
  case t.kind
  of tkSimple:
    t.name
  of tkComposite:
    t.name & "[" & $t.param & "]"
  of tkStruct:
    t.name & "(" & $(t.fields) & ")"
    

####################################################################################################
# Repository

proc newRepository*(): Repository =
  new result
  result[] = initTable[string, Type]()

proc add*(r: Repository, t: Type): Repository {.discardable.}=
  r[t.name] = t
  r

proc get*(r: Repository, name: string): Option[Type] =
  if r.hasKey name: r[name].some else: Type.none

proc `$`*(r: Repository): string =
  $(r[])
