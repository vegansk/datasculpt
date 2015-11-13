template dep*(task: untyped): stmt =
  exec "nim " & astToStr(task)

template deps*(task1: untyped, task2: untyped): stmt =
  dep task1
  dep task2
  
template deps*(task1: untyped, task2: untyped, task3: untyped): stmt =
  deps task1, task2
  dep task3
