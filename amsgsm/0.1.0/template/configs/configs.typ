#import "@runge/thm:0.1.0": theorem-rules

#let text-config = it => {
  it
}

#let equation-config = it => {
  show math.equation.where(block: true): set block(breakable: true)
  it
}

#let equation-numbering-config = it => {
  show <nonumbering>: set math.equation(numbering: none)
  show math.equation.where(block: true): it => {
    if not it.has("label") {
      let fields = it.fields()
      _ = fields.remove("body")
      _ = fields.numbering = none
      [
        #block(width: 100%)[#math.equation(
            ..fields,
            it.body,
          )<nonumbering>]]
    } else {
      it
    }
  }
  it
}

#let heading-numbering-config(
  toplevel: i => "Chapter " + numbering("1", i),
  drop-toplevel: (..its) => numbering("§1.1.a.i.", ..its),
) = it => {
  set heading(
    numbering: (..sink) => {
      if sink.pos().len() == 1 {
        return toplevel(sink.pos().at(0))
      } else {
        return drop-toplevel(..sink.pos().slice(1))
      }
    },
  )
  it
}

#let appendix-numbering-config = heading-numbering-config.with(toplevel: i => "Appendix " + numbering("A", i))

#let heading-config = it => {
  show heading.where(numbering: none).and(heading.where(level: 1)): h0 => {
    pagebreak(weak: true)
    line(length: 100%, stroke: 1pt)
    v(7em)
    text(size: 2em, weight: "bold", h0.body)
    v(3em)
  }

  show heading.where(level: 1): h0 => {
    if h0.numbering == none {
      h0
    } else {
      pagebreak(weak: true)
      line(length: 100%, stroke: 1pt)
      place(
        right + top,
        stack(
          spacing: .5em,
          rect(width: 7em, height: 0.5em, fill: black),
          text(
            style: "italic",
            size: 1.2em,
            weight: "regular",
            numbering(h0.numbering, ..counter(heading).get()),
          ),
        ),
      )
      v(5em)
      text(size: 2em, weight: "bold", h0.body)
      v(5em)
    }
  }

  show heading: hi => {
    if hi.numbering == none or hi.level == 1 {
      hi
    } else if hi.level == 2 {
      v(.5em)
      par(
        first-line-indent: 0pt,
        text(
          size: 1.2em,
          weight: "bold",
          numbering(hi.numbering, ..counter(heading).get()) + [#h(.3em)] + hi.body,
        ),
      )
      v(.5em, weak: false)
    } else {
      text(
        size: 1em,
        weight: "bold",
        numbering(hi.numbering, ..counter(heading).get()) + [#h(.3em)] + hi.body,
      )
      h(.3em)
    }
  }

  it
}


#let outline-config = it => {
  set outline(
    indent: n => {
      if n == 0 {
        0em
      } else {
        2em
      }
    },
  )
  show outline.entry.where(level: 1): oe => {
    v(.4em)
    oe.indented(
      if oe.prefix() != none {
        text(weight: "bold", oe.prefix())
      },
      link(oe.element.location(), text(weight: "bold", oe.inner())),
      gap: 2em,
    )
    v(.2em)
  }
  show outline.entry: oe => {
    if oe.level == 1 {
      return oe
    }
    oe.indented(
      box(width: 2em, text(oe.prefix())),
      link(oe.element.location(), oe.inner()),
      gap: 1em,
    )
  }
  it
}
