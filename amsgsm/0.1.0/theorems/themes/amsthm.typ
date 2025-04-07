#import "../components/exports.typ": *
#import "../theorems.typ": new-theorem
#import "../l10n.typ": theorem-name-l10n as _thmname
#import "@preview/rich-counters:0.2.2": rich-counter

#import "../utils/utils.typ": *

#let theorem-counter = rich-counter(identifier: "theorem", inherited_levels: 2)
#let axiom-counter = rich-counter(identifier: "axiom", inherited_levels: 2)
#let definition-counter = rich-counter(
  identifier: "definition",
  inherited_levels: 2,
)
#let corollary-counter = rich-counter(
  identifier: "corollary",
  inherited_levels: 3,
  inherited_from: theorem-counter,
)
#let law-counter = rich-counter(
  identifier: "law",
  inherited_levels: 2,
)
#let principle-counter = rich-counter(
  identifier: "principle",
  inherited_levels: 2,
)

#let render-function = renderers.renderer-builder(
  description-function: descriptions.description-builder(final-sym: [*.*]),
  number-formatter: configs.config-text(inner-configs: (strong,)),
  title-formatter: configs.config-text(
    inner-configs: (text-wrappers.parenthit,),
  ),
  prefix-formatter: configs.config-text(inner-configs: (strong,)),
  body-function: configs.config-text(
    style: "italic",
    inner-configs: (arr => arr.join(),),
  ),
  block-function: configs.config-block(
    radius: 0em,
    breakable: true,
    width: 100%,
    inset: (x: 0em, top: 0em, bottom: 0em),
  ),
)
#let definition-render-function = render-function.with(
  body-function: configs.config-text(
    style: "normal",
    inner-configs: (arr => arr.join(),),
  ),
)
#let proof-render-function = render-function.with(
  body-function: configs.config-text(
    style: "normal",
    inner-configs: (arr => arr.join(),),
  ),
  prefix-formatter: configs.config-text(
    inner-configs: (
      configs.config-text(style: "italic"),
    ),
  ),
)
#let remark-render-function = definition-render-function.with(
  title-formatter: configs.config-text(
    style: "italic",
    inner-configs: (text-wrappers.parenthit,),
  ),
  prefix-formatter: configs.config-text(style: "italic"),
)

#let new-block-theorem(
  identifier: none,
  name: auto,
  kind: auto,
  counter: none,
  numbering: auto,
  prefix: auto,
  suffix: auto,
  supplement-function: auto,
  render-function: render-function,
  ..block-args,
) = {
  assert(identifier != none, message: "identifier shall not be none!")
  let name = if name != auto and name != none {
    name
  } else if name == auto {
    _thmname(identifier)
  } else {
    identifier
  }
  new-theorem(
    identifier: identifier,
    kind: kind,
    suffix: suffix,
    prefix: name,
    supplement: name,
    numbering: numbering,
    counter: counter,
    figure-function: auto,
    render-function: render-function,
    supplement-function: supplement-function,
    render-args: (
      block-args: arguments(..block-args.named()),
    ),
  )
}

// theorem-like
#let theorem = new-block-theorem(
  identifier: "theorem",
  counter: theorem-counter,
)
#let lemma = new-block-theorem(
  identifier: "lemma",
  counter: theorem-counter,
)
#let observation = new-block-theorem(
  identifier: "observation",
  counter: theorem-counter,
)
#let proposition = new-block-theorem(
  identifier: "proposition",
  counter: theorem-counter,
)
#let property = new-block-theorem(
  identifier: "property",
  counter: theorem-counter,
  supplement-function: supplements.titled-supplement-builder(
    compose-function: supplements.prefix-title-compositions.at("of"),
  ),
)
#let claim = new-block-theorem(
  identifier: "claim",
  counter: theorem-counter,
)
#let corollary = new-block-theorem(
  identifier: "corollary",
  counter: corollary-counter,
  numbering: "1.1.1.a",
)
#let law = new-block-theorem(
  identifier: "law",
  counter: law-counter,
  supplement-function: supplements.titled-supplement-builder(
    compose-function: supplements.prefix-title-compositions.at("of"),
  ),
)
#let principle = new-block-theorem(
  identifier: "principle",
  counter: principle-counter,
  supplement-function: supplements.titled-supplement-builder(
    compose-function: supplements.prefix-title-compositions.at("of"),
  ),
)
// remark-like
#let remark = new-block-theorem(
  identifier: "remark",
  render-function: remark-render-function,
  counter: none,
)
#let note = new-block-theorem(
  identifier: "note",
  counter: none,
  render-function: remark-render-function,
)
#let comment = new-block-theorem(
  identifier: "comment",
  counter: none,
  render-function: remark-render-function,
)
// definitoin-like
#let definition = new-block-theorem(
  identifier: "definition",
  counter: definition-counter,
  render-function: definition-render-function,
  supplement-function: supplements.titled-supplement-builder(
    compose-function: supplements.prefix-title-compositions.at("of"),
  ),
)
#let convention = new-block-theorem(
  identifier: "convention",
  render-function: definition-render-function,
  counter: definition-counter,
)
#let axiom = new-block-theorem(
  identifier: "axiom",
  render-function: definition-render-function,
  counter: axiom-counter,
)
#let postulate = new-block-theorem(
  identifier: "postulate",
  render-function: definition-render-function,
  counter: axiom-counter,
)
#let proof = new-block-theorem(
  identifier: "proof",
  render-function: proof-render-function,
  counter: none,
  suffix: [
    #let quater-rest = box(inset: (bottom: -3.5pt))[\u{1D13D}]
    #[#h(1fr)#quater-rest]
    #counter(math.equation).update(0)
  ],
)
#let example = new-block-theorem(
  identifier: "example",
  render-function: definition-render-function,
  counter: none,
)
