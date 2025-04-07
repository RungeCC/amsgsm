#import "../utils/utils.typ": *

#let description-builder(
  outer-function: _id1,
  prefix-number-sep: [ ],
  prefix-title-sep: [ ],
  number-title-sep: [ ],
  final-sym: [:],
  initial-sym: [],
) = (prefix: none, number: none, title: none, ..extra-args) => {
  let prefixed = prefix != none
  let numbered = number != none
  let titled = title != none
  if not prefixed {
    return none
  }
  return outer-function(
    [#initial-sym]
      + (
        if numbered and titled {
          [#prefix#prefix-title-sep#number#number-title-sep#title]
        } else if numbered and not titled {
          [#prefix#prefix-title-sep#number]
        } else if not numbered and titled {
          [#prefix#prefix-title-sep#title]
        } else if not numbered and not titled {
          [#prefix]
        }
      )
      + [#final-sym],
    ..extra-args,
  )
}

#let outline-description-builder(
  place-args: arguments(left + top, dy: -17.5pt, dx: 10pt),
  box-args: (
    fill: white,
    stroke: (x: 1pt),
    outset: (x: 4pt, y: 4pt),
    radius: 3pt,
  ),
  prefix-number-sep: [ ],
  prefix-title-sep: [ ],
  number-title-sep: [ ],
  final-sym: [:],
  initial-sym: [],
) = description-builder(
  prefix-number-sep: prefix-number-sep,
  prefix-title-sep: prefix-title-sep,
  number-title-sep: number-title-sep,
  final-sym: final-sym,
  initial-sym: initial-sym,
  outer-function: (body, ..args) => place(..place-args, box(..box-args, body)),
)
