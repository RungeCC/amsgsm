#import "../utils/utils.typ": *

#let plain-supplement-builder(
  prefix-function: _id,
  number-function: _id,
  title-function: _first-maybe-none(it => [(#it)]),
  outer-function: _id1,
  prefix-number-sep: [ ],
  prefix-title-sep: [ ],
  number-title-sep: [ ],
) = (
  prefix: none,
  number: none,
  title: none,
  ..extra-args,
) => {
  let prefixed = prefix != none
  let numbered = number != none
  let titled = title != none
  if not prefixed {
    return none
  }
  let prefix = prefix-function(prefix)
  let number = number-function(number)
  let title = title-function(title)
  return outer-function(
    (
      if numbered and titled {
        [#prefix#prefix-title-sep#number#number-title-sep#title]
      } else if numbered and not titled {
        [#prefix#prefix-title-sep#number]
      } else if not numbered and titled {
        [#prefix#prefix-title-sep#title]
      } else if not numbered and not titled {
        [#prefix]
      }
    ),
    ..extra-args,
  )
}

#let numbered-supplement-builder(
  prefix-function: _id,
  number-function: _id,
  outer-function: _id1,
  prefix-number-sep: [ ],
) = (prefix: none, number: none, title: none, ..extra-args) => {
  let prefixed = prefix != none
  let numbered = number != none
  if not prefixed {
    return none
  }
  return outer-function(
    (
      if numbered {
        [#prefix-function(prefix)#prefix-number-sep#number-function(number)]
      } else {
        [#prefix-function(prefix)]
      }
    ),
    ..extra-args,
  )
}

#let prefix-title-compositions = (
  "of": (prefix, title) => [#prefix of #title],
  "plain": (prefix, title) => [#title #prefix],
  "belongs": (prefix, title) => [#title's #prefix],
  "belong": (prefix, title) => [[#title]s' #prefix],
)

#let titled-supplement-builder(
  prefix-function: _id,
  title-function: _id,
  compose-function: (prefix, title) => [#title #prefix],
  outer-function: _id1,
  fallback: numbered-supplement-builder(),
) = (
  prefix: none,
  number: none,
  title: none,
  ..extra-args,
) => {
  let prefixed = prefix != none
  let numbered = number != none
  let titled = title != none
  if not prefixed {
    return none
  }
  if not titled {
    return fallback(
      prefix: prefix,
      number: number,
      title: title,
      ..extra-args,
    )
  }
  outer-function(
    compose-function(
      prefix-function(prefix),
      title-function(title),
    ),
    ..extra-args,
  )
}
