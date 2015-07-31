import macros

## Data structures description language and modeling tool

type
  ## Optional value concept
  Optional*[T] = concept c
    hasValue(c) is bool
    get(c) is T
  ## Optional value default implementation
  Option*[T] = object
    case hasValueF: bool
    of true:
      value: T
    of false:
      discard

proc some*[T](v: T): Option[T] =
  Option[T](hasValueF: true, value: v)
proc none*[T](): Option[T] = Option[T](hasValueF: false)
proc hasValue*[T](o: Option[T]): bool = o.hasValueF
proc get*[T](o: Option[T]): T =
  assert hasValue(o)
  result = o.value

iterator objFields*(T: typedesc): (NimNode, NimNode) =
  ## Iterate object's fields
  expectKind T.getType[1].getType, nnkObjectTy
  let reclist = T.getType[1].getType[1]
  for i in 0..len(reclist)-1:
    yield (reclist[i], reclist[i].getType)
