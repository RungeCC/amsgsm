#import "../utils/utils.typ": *

#let config-figure(
  inner-configs: (),
  supplement: auto,
  placement: none,
  scope: "column",
  caption: none,
  outlined: false,
  ..figure-args,
) = {
  (it /* maybe none */, ..extra-fig-args) => figure(
    supplement: supplement,
    placement: placement,
    scope: scope,
    caption: caption,
    outlined: outlined,
    ..figure-args,
    ..extra-fig-args,
    _fold-application(inner-configs)(it),
  )
}

#let config-block(
  inner-configs: (),
  fill: white,
  stroke: none,
  radius: .3em,
  breakable: true,
  width: 100%,
  inset: (x: 1em, top: 1em, bottom: 1em),
  outset: (:),
  above: auto,
  below: auto,
  ..block-args,
) = {
  (it /* maybe none */, ..extra-block-args) => block(
    fill: fill,
    stroke: stroke,
    radius: radius,
    breakable: breakable,
    width: width,
    inset: inset,
    above: above,
    below: below,
    outset: outset,
    ..block-args,
    ..extra-block-args,
    _fold-application(inner-configs)(it),
  )
}

#let config-box(
  inner-configs: (),
  fill: white,
  stroke: none,
  radius: .3em,
  width: 100%,
  inset: (x: 1em, top: 1em, bottom: 1em),
  outset: (:),
  clip: false,
) = {
  (it /* maybe none */, ..extra-block-args) => box(
    fill: fill,
    stroke: stroke,
    radius: radius,
    width: width,
    inset: inset,
    outset: outset,
    clip: clip,
    _fold-application(inner-configs)(it),
  )
}

/// Similar with `text.with(..args)`, but handle the case `it == none`.
/// Builtin `text` will return ``[]`` (which is a empty `sequnece`) but our
/// version will return `none`. Our outside functions only perform `none`-check.
///
/// -> function
#let config-text(
  inner-configs: (),
  font: _default,
  style: "normal",
  fill: black,
  tracking: 0pt,
  weight: "regular",
  lang: "en",
  region: "US",
  number-type: auto,
  fractions: false,
  ..text-args,
) = {
  (it /* maybe none */, ..extra-text-args) => text(
    .._dedefaults(
      font: font,
      style: style,
      fill: fill,
      weight: weight,
      lang: lang,
      region: region,
      tracking: tracking,
      number-type: number-type,
      fractions: fractions,
      ..text-args,
    ),
    ..extra-text-args,
    _fold-application(inner-configs)(it),
  )
}
