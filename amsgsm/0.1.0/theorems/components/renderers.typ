#import "../utils/utils.typ": *

#import "descriptions.typ": *
#import "structures.typ": *
#import "text-wrappers.typ": *
#import "configs.typ": *

#let renderer-builder = (
  // formatters
  prefix-formatter: config-text(inner-configs: (strong,)),
  title-formatter: config-text(inner-configs: (parenthit,)),
  number-formatter: config-text(inner-configs: (strong,)),
  // structural functions
  structure-function: structure-builder(),
  description-function: description-builder(),
  body-function: arr => arr.join(),
  block-function: config-block(),
) => {
  let inherited = (
    prefix-formatter: prefix-formatter,
    title-formatter: title-formatter,
    number-formatter: number-formatter,
    structure-function: structure-function,
    description-function: description-function,
    body-function: body-function,
    block-function: block-function,
  )
  // return an overridable renderer
  (
    init: _get-none,
    metainfo: none,
    prefix: none,
    title: none,
    number: none,
    suffix: none,
    contents: (),
    prefix-formatter: prefix-formatter,
    title-formatter: title-formatter,
    number-formatter: number-formatter,
    // structural functions
    structure-function: structure-function,
    description-function: description-function,
    body-function: body-function,
    block-function: block-function,
    // extra args
    prefix-args: _empty-args,
    title-args: _empty-args,
    number-args: _empty-args,
    structure-args: _empty-args,
    description-args: _empty-args,
    body-args: _empty-args,
    block-args: _empty-args,
  ) => {
    let self = (
      prefix-formatter: prefix-formatter,
      title-formatter: title-formatter,
      number-formatter: number-formatter,
      structure-function: structure-function,
      description-function: description-function,
      body-function: body-function,
      block-function: block-function,
    )
    let resolve(method) = _auto-or-empty-none-map(
      // if self.method is none or auto, fallback to inderited one
      self.at(method),
      inherited.at(method),
      _first-maybe-none,
    )
    let resolve-unhooked(method) = _auto-or-empty-none-map(
      // if self.method is none or auto, fallback to inderited one
      self.at(method),
      inherited.at(method),
      _id,
    )
    let prefix = resolve("prefix-formatter")(
      prefix,
      ..prefix-args,
    )
    let title = resolve("title-formatter")(
      title,
      ..title-args,
    )
    let number = resolve("number-formatter")(
      number,
      ..number-args,
    )
    let body = resolve("body-function")(
      contents,
      ..body-args,
    )
    let description = resolve-unhooked("description-function")(
      prefix: prefix,
      title: title,
      number: number,
      ..description-args,
    )
    let structure = resolve-unhooked("structure-function")(
      description: description,
      body: body,
      suffix: suffix,
      ..structure-args,
    )
    let block = resolve("block-function")(
      [#init()#metainfo#structure],
      ..block-args,
    )
    block
  }
}
