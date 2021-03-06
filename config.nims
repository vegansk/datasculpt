import project/project

version       = "0.0.1"
author        = "Anatoly Galiulin <galiulin.anatoly@gmail.com>"
description   = "Data structure description language"
license       = "MIT"
srcdir        = "src"
bin           = @["dsculpt"]

requires "nim >= 0.12.1", "https://github.com/vegansk/nimfp#master"

proc buildBase(debug = true, bin: string, src: string) =
  switch("out", (thisDir() & "/" & bin).toExe)
  --nimcache: build
  if not debug:
    --forceBuild
    --define: release
    --opt: size
  else:
    --define: debug
    --debuginfo
    --debugger: native
    --linedir: on
    --stacktrace: on
    --linetrace: on
    --verbosity: 1

    --NimblePath: src
    --NimblePath: srcdir
    
  setCommand "c", src

proc test(name: string) =
  if not dirExists "bin_tests":
    mkDir "bin_tests"
  --run
  buildBase true, "bin_tests/test_" & name, "tests/test_" & name

task test, "Run all tests":
  test "all"

task dsl, "Run dsl tests":
  test "dsl"

task model, "Run model tests":
  test "model"

task install, "Install datasculpt using nimble":
 exec "nimble install -y"
