import macros, fp/option

proc defType(t: expr): untyped
proc parseTypeFromBrackets(t: expr): untyped =
  expectKind t, nnkBracketExpr
  expectLen t, 2
  expectKind t[0], nnkIdent
  let b = t[0].toStrLit
  result = quote do:
    echo `b`
  case t[1].kind
  of nnkIdent:
    let b = t[1].toStrLit
    result.add(quote do: echo `b`)
  of nnkBracketExpr:
    result.add(parseTypeFromBrackets t[1])
  else:
    error "Unknown bracket body kind: " & $t[1].kind

proc defType(t: expr): untyped =
  expectKind t, nnkStmtList
  let b = t.toStrLit
  case t[0].kind
  of nnkIdent:
    # Simple type
    let n = t[0].toStrLit
    result = quote do: echo `n`
  of nnkBracketExpr:
    result = parseTypeFromBrackets t[0]
  else:
    error "Unknown type's node kind: " & $t[0].kind

proc defField(f: expr, desc: Option[string]): untyped =
  expectKind f, nnkCall
  expectLen f, 2
  expectKind f[0], nnkIdent

  let name = f[0].toStrLit
  let c = desc.getOrElse("")
  result = quote do:
    echo "   Field: " & `name` & ", comment: " & `c`
  result.add(defType f[1])

proc parseComment(c: NimNode): Option[string] =
  # TODO: Read the comments from the source
  "TODO: Read the comments from the source".some

macro defStruct*(name: expr, body: expr): stmt =
  let n = name.toStrLit
  let b = body.toStrLit
  expectKind body, nnkStmtList
  result = quote do:
    echo "Name: " & `n`
  var comment = string.none
  for n in body.children:
    case n.kind
    of nnkCall:
      result.add(defField(n, comment))
      comment = string.none
    of nnkCommentStmt:
      comment = parseComment(n)
    else:
      error "Unknown node kind: " & $n.kind
