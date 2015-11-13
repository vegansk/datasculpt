import macros

macro defStruct*(name: untyped, body: untyped): stmt =
  let n = name.toStrLit
  let b = body.toStrLit
  result = quote do:
    echo "Name: " & `n`
    echo "Body: " & `b`
  
