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

#let render-function-builder(border-color, background-color) = {
  let background-color = _auto-or(
    background-color,
    color.mix(border-color, white),
  )
  renderers.renderer-builder(
    // main render function
    title-formatter: configs.config-text(
      inner-configs: (strong, text-wrappers.parenthit),
    ),
    number-formatter: configs.config-text(inner-configs: (strong,)),
    block-function: configs.config-block(
      radius: 0em,
      breakable: true,
      width: 100%,
      fill: background-color,
      stroke: (left: border-color + 2pt, rest: 0pt),
      inset: (x: 1em, top: 1em, bottom: 1em),
    ),
  )
}

#let new-block-theorem(
  identifier: none,
  name: auto,
  kind: auto,
  counter: none,
  numbering: auto,
  prefix: auto,
  suffix: auto,
  supplement-function: auto,
  border-color: tailwind.sky-400,
  background-color: auto,
  render-function: auto,
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
    render-function: _auto-or(
      render-function,
      render-function-builder(border-color, background-color),
    ),
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
  border-color: tailwind.indigo-400,
  background-color: tailwind.indigo-100,
)
#let postulate = new-block-theorem(
  identifier: "postulate",
  counter: axiom-counter,
  border-color: tailwind.amber-400,
  background-color: tailwind.amber-100,
)

// theorem-like
#let theorem = new-block-theorem(
  identifier: "theorem",
  counter: theorem-counter,
  border-color: tailwind.sky-400,
  background-color: tailwind.sky-100,
)
#let lemma = new-block-theorem(
  identifier: "lemma",
  counter: theorem-counter,
  border-color: tailwind.teal-400,
  background-color: tailwind.teal-100,
)
#let observation = new-block-theorem(
  identifier: "observation",
  counter: theorem-counter,
  border-color: tailwind.teal-400,
  background-color: tailwind.teal-100,
)
#let proposition = new-block-theorem(
  identifier: "proposition",
  counter: theorem-counter,
  border-color: tailwind.cyan-400,
  background-color: tailwind.cyan-100,
)
#let property = new-block-theorem(
  identifier: "property",
  counter: theorem-counter,
  border-color: tailwind.fuchsia-400,
  background-color: tailwind.fuchsia-100,
  supplement-function: supplements.titled-supplement-builder(
    compose-function: supplements.prefix-title-compositions.at("of"),
  ),
)
#let claim = new-block-theorem(
  identifier: "claim",
  counter: theorem-counter,
  border-color: tailwind.lime-400,
  background-color: tailwind.lime-100,
)
#let corollary = new-block-theorem(
  identifier: "corollary",
  counter: corollary-counter,
  numbering: "1.1.1.a",
  border-color: tailwind.rose-400,
  background-color: tailwind.rose-100,
)
// definitoin-like
#let definition = new-block-theorem(
  identifier: "definition",
  counter: definition-counter,
  border-color: tailwind.amber-400,
  background-color: tailwind.amber-100,
  supplement-function: supplements.titled-supplement-builder(
    compose-function: supplements.prefix-title-compositions.at("of"),
  ),
)
#let convention = new-block-theorem(
  identifier: "convention",
  counter: definition-counter,
  border-color: tailwind.blue-400,
  background-color: white,
  stroke: (left: 2pt + tailwind.blue-800),
)
// example-like
#let example = new-block-theorem(
  identifier: "example",
  counter: none,
  border-color: tailwind.gray-400,
  background-color: tailwind.gray-100,
)
// remark-like
#let remark = new-block-theorem(
  identifier: "remark",
  counter: none,
  border-color: tailwind.green-400,
  background-color: tailwind.green-100,
)
#let note = new-block-theorem(
  identifier: "note",
  counter: none,
  border-color: tailwind.green-400,
  background-color: tailwind.green-100,
)
#let comment = new-block-theorem(
  identifier: "comment",
  counter: none,
  border-color: tailwind.green-400,
  background-color: tailwind.green-100,
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
  border-color: tailwind.purple-400,
  background-color: white,
)

// non math environments, laws and principles
#let law = new-block-theorem(
  identifier: "law",
  counter: law-counter,
  supplement-function: supplements.titled-supplement-builder(
    compose-function: supplements.prefix-title-compositions.at("of"),
  ),
  border-color: tailwind.blue-400,
  background-color: tailwind.blue-100,
)
#let principle = new-block-theorem(
  identifier: "principle",
  counter: principle-counter,
  supplement-function: supplements.titled-supplement-builder(
    compose-function: supplements.prefix-title-compositions.at("of"),
  ),
  border-color: tailwind.purple-400,
  background-color: tailwind.purple-100,
)
