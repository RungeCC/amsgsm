#import "utils/utils.typ": *
#import "dedefaults.typ": *

#let new-theorem(
  identifier: "theorem",
  counter: auto,
  kind: auto,
  prefix: auto,
  suffix: none,
  numbering: auto,
  supplement: auto,
  figure-function: auto, // just an option for overriding figure
  render-function: auto, // (metainfo, prefix, title?, counter?, numbering?, suffix, ...body) -> content
  supplement-function: auto, // (get-metainfo, suffix?, title?, counter?, numbering?) -> content
  metainfo: auto,
  figure-args: _empty-args, // remained for restate
  render-args: _empty-args, // remained for restate
  supplement-args: _empty-args,  // remained for restate
) = {
  let args = _dedefaults-theorem-args(
    identifier: identifier, // name of your theorem
    counter: counter,
    kind: kind,
    prefix: prefix, // if none, be theorem-name
    suffix: suffix,
    supplement: supplement, // if none, be name
    numbering: numbering,
    // formatters
    figure-function: figure-function,
    render-function: render-function,
    // structures
    supplement-function: supplement-function,
    // metainfo
    metainfo: metainfo,
  )

  return (
    // title and label belong to instance only
    title: none,
    label: none,
    // override primary fields, notice that you can not override `kind`
    prefix: args.prefix,
    suffix: args.suffix,
    supplement: args.supplement,
    counter: args.counter,
    numbering: args.numbering,
    // "deeper" override
    number: auto,
    // override builders
    figure-function: args.figure-function,
    render-function: args.render-function,
    // extra-metainfo
    extra-metainfo: (:),
    // extra-args
    extra-render-args: _empty-args,
    extra-figure-args: _empty-args,
    extra-supplement-args: _empty-args,
    ..sink,
  ) => {
   let (
      prefix,
      suffix,
      supplement,
      numbering,
      counter,
      number,
      figure-function,
      render-function,
      supplement-function,
      metainfo,
    ) = _dedefaults-theorem-args(
      identifier: identifier,
      kind: kind,

      prefix: prefix,
      suffix: suffix,
      supplement: supplement,
      numbering: numbering,
      counter: counter,

      number: number,

      supplement-function: supplement-function,

      render-function: render-function,
      figure-function: figure-function,

      metainfo: metainfo,
    )
    let counted = counter != none
    let numbered = numbering != none
    let need-step = counted and numbered
    let counter = _wrap-counter(counter)
    let number = _auto-or(
      number,
      _none-then(
        counter,
        it => {
          if (numbered) {
            context std.numbering(numbering, ..(it.get)())
          } else {
            none
          }
        },
      ),
    )
    assert(
      sink.named().len() == 0,
      message: "Unknown arguments: " + repr(sink.named().keys()),
    )
    let contents = sink.pos()

    let metainfo = (
      metainfo
        + (
          title: title,
          counter: counter,
          supplement-args: arguments(
            ..supplement-args,
            ..extra-supplement-args,
          ),
        ) // override
        + extra-metainfo
    )
    let fig = figure-function(
      supplement: supplement,
      ..figure-args,
      ..extra-figure-args,
      render-function(
        init: () => {
          if counted { (counter.step)() }
        },
        metainfo: [#metadata(metainfo)#std.label("meta:thm:metainfo")],
        prefix: prefix,
        title: title,
        number: number,
        suffix: suffix,
        contents: contents,
        ..render-args,
        ..extra-render-args,
      ),
    )
    return if (type(label) == std.label) [#fig#label] else { fig }
  }
}

#let ref-theorem(
  label,
  supplement: auto,
  supplement-function: auto,
  numbering: auto,
  title: auto,
  ..extra-supplement-args,
) = context {
  assert(type(label) == std.label)
  let datas = query(selector(std.label("meta:thm:metainfo")).after(label))
  let (data, loc) = if datas.len() != 0 {
    (datas.first().value, datas.first().location())
  } else {
    return
  }
  let supplement-function = _auto-or(
    supplement-function,
    data.supplement-function,
  )
  let supplement = _auto-or(supplement, data.supplement)
  let title = _auto-or(title, data.title)
  let counter = data.counter
  let numbering = _auto-or(numbering, data.numbering)

  let number = if numbering != none and counter != none {
    { std.numbering(numbering, ..(counter.at)(loc)) }
  } else {
    none
  }
  link(
    label,
    [#supplement-function(
        prefix: supplement,
        number: number,
        title: title,
        ..data.supplement-args,
        ..extra-supplement-args,
      )],
  )
}

#let is-theorem(kind, kinds) = (
  if type(kinds) == array {
    kinds.contains(kind)
  } else if type(kinds) == function {
    kinds(kind)
  } else {
    false
  }
)

#let theorem-rules(
  kinds: auto,
  display: true,
  body
) = context {
  let kinds = (
    _auto-or(
      kinds,
      ("theorem-counted", "theorem-uncounted"),
    )
      + ("theorem-counted", "theorem-uncounted")
  ).dedup()
  show figure: it => {
    if not is-theorem(it.kind, kinds) {
      return it
    }
    if display {
      set align(start)
      set block(breakable: true)
      it
    }
  }

  show ref: it => {
    if it.element == none {
      return it
    }
    if it.element.func() != figure {
      return it
    }
    if not is-theorem(it.element.kind, kinds) {
      return it
    }
    ref-theorem(it.target, supplement: it.supplement)
  }
  body
}
