#import "../utils/utils.typ": *

#let structure-builder(
  separator: h(.2em),
  outer-function: _id1,
  ..extra-args,
) = {
  (
    description: none,
    body: none,
    suffix: none,
    ..args,
  ) => {
    outer-function(
      if description != none {
        [#description#separator#body#suffix]
      } else {
        [#body#suffix]
      },
      ..extra-args,
    )
  }
}