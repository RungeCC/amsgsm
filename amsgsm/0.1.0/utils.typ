#let _evalc = eval.with(mode: "markup")
#let _evalm = eval.with(mode: "math")
#let _evalx = eval.with(mode: "code")

#let evals = (
  c: _evalc,
  m: _evalm,
  x: _evalx,
)

#let _fold(func, init, list) = list.fold(
  init,
  func,
)

/// first item will be applied first!
#let _fold-application(rules) = it => _fold(
  (i, rule) => rule(i),
  it,
  rules,
)

#let _normalize-configs(configs) = {
  if type(configs) == array {
    configs
  } else if type(configs) == function {
    (configs,)
  } else {
    ()
  }
}

#let _rewrap-configs(default-configs: (), necessary-configs: ()) = {
  (
    body,
    outer-configs: (),
    inner-configs: (),
    applying-default-configs: true,
  ) => {
    let configs = (
      _normalize-configs(inner-configs)
        + _normalize-configs(necessary-configs)
        + if applying-default-configs {
          _normalize-configs(default-configs)
        } else {
          ()
        }
        + _normalize-configs(outer-configs)
    )
    return _fold-application(configs)(body)
  }
}

#let _combine-configs(..configs) = {
  return _fold-application(
    configs.pos().map(it => _normalize-configs(it)).join(),
  )
}

#let _content-to-str(it) = {
  return if type(it) == str {
    it
  } else if it == [ ] {
    " "
  } else if it.has("children") {
    it.children.map(_content-to-str).join()
  } else if it.has("body") {
    _content-to-str(it.body)
  } else if it.has("text") {
    if type(it.text) == str {
      it.text
    } else {
      _content-to-str(it.text)
    }
  } else {
    let func = it.func()
    if func in (parbreak, pagebreak, linebreak) {
      "\n"
    } else if func == smartquote {
      if it.double { "\"" } else { "'" }
    } else if it.fields() == (:) {
      ""
    } else if repr(func) == "styled" {
      it.child
    } else {
      repr(it)
    }
  }
}
