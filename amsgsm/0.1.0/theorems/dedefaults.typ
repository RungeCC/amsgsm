#import "utils/utils.typ": *
#import "components/exports.typ" as components

#let _dedefaults-basic-infos(
  args,
) = {
  assert(
    type(args.identifier) == str,
    message: "argument `identifier` expects `str`, `"
      + repr(type(args.identifier))
      + "` received",
  )
  args.counter = _auto-or-none(args.counter)
  let counted = counter != none
  args.kind = _auto-or(
    args.kind,
    if counted {
      "theorem-counted"
    } else {
      "theorem-uncounted"
    },
  )
  assert(args.kind != none)
  args.prefix = _auto-or(args.prefix, args.identifier)
  args.suffix = _auto-or-none(args.suffix)
  args.supplement = _auto-or(
    args.supplement,
    args.prefix,
  ) // by defualt, it's prefix, and could be none
  args.numbering = _auto-or(args.numbering, "1.1")
  return args
}

#let _dedefaults-figure(
  args,
) = {
  args.figure-function = _auto-or-empty-none-map(
    args.figure-function,
    components.configs.config-figure(
      kind: args.kind,
      supplement: args.supplement,
      placement: none,
      outlined: false,
    ),
    _first-maybe-none,
  )
  return args
}

#let _dedefaults-renders(
  args,
) = {
  args.reunder-function = components.renderers.renderer-builder()
  args.supplement-function = components.supplements.plain-supplement-builder()
  return args
}

#let _dedefaults-metainfo(
  args,
) = {
  let default-metainfo = (
    identifier: args.identifier,
    counter: args.counter,
    numbering: args.numbering,
    supplement: args.supplement,
    supplement-function: args.supplement-function,
  )
  args.metainfo = (
    default-metainfo
      + _auto-none-default(
        args.metainfo,
        default-metainfo,
        default-metainfo,
      )
  )
  return args
}

#let _dedefaults-theorem-args(
  ..args,
) = {
  let args = args.named()
  return _fold-application-seq(
    _dedefaults-basic-infos,
    _dedefaults-figure,
    _dedefaults-renders,
    _dedefaults-metainfo,
  )(args)
}
