import macros, model, future, fp.option, strutils, sequtils

proc parseType(t: expr): string

proc parseTypeFromBrackets(t: expr): string =
  expectKind t, nnkBracketExpr
  expectLen t, 2
  expectKind t[0], nnkIdent
  let ident = $t[0]
  "complexType(\"" & ident & "\", " & parseType(t[1])  & ")"

proc parseType(t: expr): string =
  if t.kind notin {nnkStmtList, nnkIdent, nnkBracketExpr}:
    error("Expected a node of kind nnkIdent or nnkStmtList or nnkBracketExpr, got " & $t.kind)
  let typ = if t.kind == nnkIdent or t.kind == nnkBracketExpr: t else: t[0]
  case typ.kind
  of nnkIdent:
    # Simple type
    result = "simpleType(\"" & $typ & "\")"
  of nnkBracketExpr:
    result = parseTypeFromBrackets typ
  else:
    error "Unknown type's node kind: " & $t[0].kind

proc parseField(f: expr, comm: Option[string]): string =
  expectKind f, nnkCall
  expectLen f, 2
  expectKind f[0], {nnkIdent, nnkAccQuoted}
  
  # TODO: Fix commented line and delete ugly transform
  # let c = comm.map(v => ("\"$1\".some"%v)).getOrElse("string.none")
  let c = if comm.isDefined: "\"" & comm.getOrElse("") & "\".some" else: "string.none"

  let i = if f[0].kind == nnkAccQuoted: f[0][0] else: f[0];

  result = "field(\"" & $i & "\", " & c & ", " & parseType(f[1]) & ")"

proc parseComment(c: NimNode): Option[string] =
  # TODO: Find out what the f... with Option.map in macros and fix multiline comments
  # c.strVal.some.notEmpty.map(v => strip(v[2..^0]))
  let comm = c.strVal.strip
  if comm != "":
    comm.split("\n").mapIt(it[2..^0].strip).join("\n").some
  else:
    comm.none

proc parseStruct(name: expr, body: NimNode): string =
  expectKind body, nnkStmtList
  var fields: seq[string] = @[]
  var comment = string.none
  for n in body.children:
    case n.kind
    of nnkCall:
      add(fields, parseField(n, comment))
      comment = string.none
    of nnkCommentStmt:
      comment = parseComment(n)
    else:
      error "Unknown node kind: " & $n.kind
  result = "struct(\"" & $name & "\", " & $fields & ")"
  echo result

macro defStruct*(r: Repository, name: expr, body: stmt): stmt {.immediate.} =
  ## Create structure definition
  let st = parseStruct(name, body).parseExpr()
  result = quote do:
    `r`.add(`st`)
