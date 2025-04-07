#let _default = metadata("theorem-default")

#let _is-default(x) = x == _default

#let _dedefaults(..arg) = {
  let pos = arg.pos()
  let named = arg.named()
  let finalarr = ()
  let finaldict = (:)
  for i in pos {
    if not _is-default(i) {
      finalarr.push(i)
    }
  }
  for (k, v) in named {
    if not _is-default(v) {
      finaldict.insert(k, v)
    }
  }
  return arguments(..finalarr, ..finaldict)
}

#let _id = it => it

#let _id1 = (f, ..extra) => f

#let _last = (..extra, l) => l

#let _empty-function = (..it) => { }

#let _empty-arr = ()

#let _empty-dict = (:)

#let _empty-args = arguments()

#let _get-none = () => none

#let _const = v => (..xs) => v

#let _fold(func, init, list) = list.fold(
  init,
  func,
)

#let _fold-application(rules) = it => _fold(
  (i, rule) => rule(i),
  it,
  rules,
)

#let _fold-application-seq(..rules) = it => _fold(
  (i, rule) => rule(i),
  it,
  rules.pos(),
)

#let _auto-or(it, value) = if it == auto {
  value
} else {
  it
}

#let _auto-or-none(it) = _auto-or(it, none)

#let _none-or(it, value) = if it == none {
  value
} else {
  it
}

#let _none-then(it, func) = if it == none {
  none
} else {
  func(it)
}

#let _wrap-counter(counter) = {
  assert(
    type(counter) == std.counter
      or type(counter) == dictionary
      or counter == none,
  )
  let __wrap-counter(counter) = {
    (
      step: (..args) => {
        counter.step(..args)
      },
      get: (..args) => {
        counter.get(..args)
      },
      at: (..args) => {
        counter.at(..args)
      },
      display: (..args) => {
        counter.display(..args)
      },
      final: (..args) => {
        counter.final(..args)
      },
    )
  }
  if type(counter) == std.counter {
    __wrap-counter(counter)
  } else if type(counter) == dictionary {
    counter
  } else {
    none
  }
}

#let _first-maybe-none(func) = {
  (it, ..rest) => _none-then(it, it => func(it, ..rest))
}

#let _auto-none-default(current, autodefault, nonedefault) = {
  if current == auto {
    autodefault
  } else if current == none {
    nonecurrent
  } else {
    current
  }
}

#let _auto-or-empty-none(current, defualt) = {
  if current == auto {
    defualt
  } else if current == none {
    _empty-function
  } else {
    current
  }
}

#let _auto-or-empty-none-map(current, defualt, transform) = {
  if current == auto {
    transform(defualt)
  } else if current == none {
    _empty-function
  } else {
    transform(current)
  }
}

#let upperfirst(t) = upper(t.first()) + t.slice(1)

