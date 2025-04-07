#import "../components/exports.typ": *
#import "../theorems.typ": new-theorem
#import "../l10n.typ": theorem-name-l10n as _thmname
#import "@preview/splash:0.4.0": tailwind
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
  // main render function
  title-formatter: configs.config-text(
    inner-configs: (strong, text-wrappers.parenthit),
  ),
  number-formatter: configs.config-text(inner-configs: (strong,)),
  block-function: configs.config-block(
    radius: .3em,
    breakable: true,
    width: 100%,
    inset: (x: 1em, top: 1em, bottom: 1em),
  ),
)

#let remark-render-function = render-function.with(
  // restate version
  block-function: (it, ..blockargs) => pad(
    configs.config-block(
      radius: .3em,
      breakable: true,
      width: 100%,
      inset: (x: 1em, top: 1em, bottom: 1em),
      ..blockargs,
    )(it),
    top: .5em,
  ),
  description-function: descriptions.outline-description-builder(
    prefix-title-sep: [: ],
    final-sym: [],
  ),
  title-formatter: configs.config-text(inner-configs: (strong,)),
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
// axiom-like
#let axiom = new-block-theorem(
  identifier: "axiom",
  counter: axiom-counter,
  fill: tailwind.indigo-100,
)
#let postulate = new-block-theorem(
  identifier: "postulate",
  counter: axiom-counter,
  fill: tailwind.amber-100,
)

// theorem-like
#let theorem = new-block-theorem(
  identifier: "theorem",
  counter: theorem-counter,
  fill: tailwind.sky-100,
)
#let lemma = new-block-theorem(
  identifier: "lemma",
  counter: theorem-counter,
  fill: tailwind.emerald-100,
)
#let observation = new-block-theorem(
  identifier: "observation",
  counter: theorem-counter,
  fill: tailwind.teal-100,
)
#let proposition = new-block-theorem(
  identifier: "proposition",
  counter: theorem-counter,
  fill: tailwind.yellow-100,
)
#let property = new-block-theorem(
  identifier: "property",
  counter: theorem-counter,
  fill: tailwind.fuchsia-100,
  supplement-function: supplements.titled-supplement-builder(
    compose-function: supplements.prefix-title-compositions.at("of"),
  ),
)
#let claim = new-block-theorem(
  identifier: "claim",
  counter: theorem-counter,
  fill: tailwind.lime-100,
)
#let corollary = new-block-theorem(
  identifier: "corollary",
  counter: corollary-counter,
  numbering: "1.1.1.a",
  fill: tailwind.rose-100,
)
// definitoin-like
#let definition = new-block-theorem(
  identifier: "definition",
  counter: definition-counter,
  supplement-function: supplements.titled-supplement-builder(
    compose-function: supplements.prefix-title-compositions.at("of"),
  ),
  stroke: rgb("1e1e1e") + 1pt,
)
#let convention = new-block-theorem(
  identifier: "convention",
  counter: definition-counter,
  stroke: (left: 2pt + tailwind.blue-800),
)
// example-like
#let example = new-block-theorem(
  identifier: "example",
  counter: none,
  fill: tailwind.gray-100,
)
// remark-like
#let remark = new-block-theorem(
  identifier: "remark",
  render-function: remark-render-function,
  counter: none,
  stroke: (top: 1pt, bottom: 1pt),
)
#let note = new-block-theorem(
  identifier: "note",
  counter: none,
  render-function: remark-render-function,
  stroke: (top: 1pt, bottom: 1pt),
)
#let comment = new-block-theorem(
  identifier: "comment",
  counter: none,
  render-function: remark-render-function,

  stroke: (top: 1pt, bottom: 1pt),
)
// proof-like
#let proof = new-block-theorem(
  identifier: "proof",
  counter: none,
  suffix: [
    #let quater-rest = box(inset: (bottom: -3.5pt))[\u{1D13D}]
    #[#h(1fr)#quater-rest]
    #counter(math.equation).update(0)
  ],
  stroke: (left: 2pt + tailwind.purple-800),
  radius: 2pt,
)

// non math environments, laws and principles
#let law = new-block-theorem(
  identifier: "law",
  counter: law-counter,
  supplement-function: supplements.titled-supplement-builder(
    compose-function: supplements.prefix-title-compositions.at("of"),
  ),
  fill: tailwind.blue-100,
)
#let principle = new-block-theorem(
  identifier: "principle",
  counter: principle-counter,
  supplement-function: supplements.titled-supplement-builder(
    compose-function: supplements.prefix-title-compositions.at("of"),
  ),
  fill: tailwind.purple-100,
)
