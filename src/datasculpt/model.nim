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

####################################################################################################
# Field

proc field*(name: string, `type`: Type): Field =
  ## Creates field with `name` and `type`
  Field(name: name, `type`: `type`)

proc `==`*(x, y: Field): bool =
  x.name == y.name and x.`type` == y.`type`

####################################################################################################
# Struct

proc struct*(name: string, fields: Fields): Struct =
  Struct(name: name, fields: fields)

proc `==`*(x, y: Struct): bool =
  x.name == y.name and x.fields == y.fields
