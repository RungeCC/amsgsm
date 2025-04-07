#import "stateful.typ": (
  outline-page,
  chapter-pages,
  meta-info,
  _title-page-exist,
)

#import "utils.typ": _fold-application

#let _make-LR-header(
  l,
  r,
  lformat: text.with(size: 8pt, weight: 400, style: "normal"),
  rformat: text.with(size: 8pt, weight: 400, style: "normal"),
  swapped: false,
) = {
  grid(columns: (1fr, 1fr), stroke: (x, y) => if y == 0 {
      (bottom: (thickness: .7pt))
    }, inset: (bottom: 3pt), grid.cell(align: left, lformat(l)), grid.cell(
      align: right,
      rformat(r),
    ))
}

#let _make-CLR-header(
  c,
  l,
  r,
  cformat: text.with(size: 8pt, weight: 400, style: "normal"),
  lformat: text.with(size: 8pt, weight: 400, style: "normal"),
  rformat: text.with(size: 8pt, weight: 400, style: "normal"),
  swapped: false,
) = {
  grid(
    columns: (1fr, 1fr, 1fr),
    stroke: (x, y) => if y == 0 {
      (bottom: (thickness: .7pt))
    },
    inset: (bottom: 3pt),
    grid.cell(align: left, lformat(l)),
    grid.cell(
      align: center,
      cformat(c),
    ),
    grid.cell(
      align: right,
      rformat(r),
    )
  )
}

#let config-metadata(
  info: (:),
) = it => {
  set document(
    title: info.short-title,
    author: info.author,
    date: info.date,
    keywords: info.at("keywords", default: none),
    description: info.at("description", default: none),
  )
  it
}

#let config-par(
  first-line-indent: 0pt,
  justify: true,
) = it => {
  set par(
    justify: justify,
    linebreaks: "optimized",
    spacing: .85em,
    first-line-indent: first-line-indent,
  )
  it
}

#let config-lang(info: (:)) = it => {
  // text settings
  set text(
    lang: info.lang,
    region: info.region,
  )
  it
}

#let config-enumitem(
  indent: 10pt,
  body-indent: 5pt,
  spacing: 13pt,
  list-marker: (
    [◦],
    [•],
    [‣],
    [–],
  ),
  enum-numbering: "a.i.1)",
) = it => {
  set enum(
    numbering: enum-numbering,
    indent: indent,
    body-indent: body-indent,
  )
  set list(
    indent: indent,
    body-indent: body-indent,
    marker: (
      [◦],
      [•],
      [‣],
      [–],
    ),
  )
  show list: set block(spacing: spacing)
  show enum: set block(spacing: spacing)
  it
}

#let config-outlined(
  indent: 10pt,
  depth: 5,
  pagebreak-after: true,
) = it => {
  set outline(
    indent: indent,
    depth: depth,
  )
  show outline.entry.where(level: 1): it => {
    box(inset: (top: .5em), strong(it))
  }
  show outline.where(target: heading.where(outlined: true)): it => {
    it
    if pagebreak-after {
      pagebreak(weak: true)
    }
  }

  it
}

#let config-bibliography(first-line-indent: 0pt) = it => {
  show bibliography: set par(first-line-indent: first-line-indent)
  it
}

#let config-heading(
  numbering: "1.1.i.a",
  format: strong,
) = it => {
  set heading(numbering: numbering)
  // modify headings' styles
  show heading: body => {
    body
    // insert
    if (body.level <= 2) {
      v(15pt, weak: true)
    }
  }
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    it
  }
  show heading: format
  it
}

#let config-counter-resetting(levels: (1, 2)) = (..counters) => (
  it => {
    show heading: h => {
      if h.level in levels {
        for c in counters.pos() {
          c.update(0)
        }
      }
      h
    }
    it
  }
)

#let config-equation-counter-resetting(
  levels: (1, 2),
) = config-counter-resetting(levels: levels)(counter(math.equation))

#let config-page-geometry(
  paper: "a4",
  margin: (left: 1in, right: 1.3in, top: 1in, bottom: 1.3in),
  ..sink,
) = it => {
  set page(
    paper: paper,
    margin: margin,
    ..sink,
  )
  it
}

#let config-page-footer(
  numbering: "1",
  number-align: center,
  footer: auto,
  info: (:),
) = it => {
  set page(
    numbering: numbering,
    number-align: number-align,
    footer: footer,
  )
  it
}

#let config-page-header(
  headerfunc: _make-LR-header,
  info: (:),
) = it => {
  set page(
    header: context {
      let loc = here()
      if (
        loc.page() > outline-page.get()
          and loc.page() not in chapter-pages.get()
      ) {
        // don't include content
        // if exactly there exist some new sections
        // then the first will be shown in header
        let cur_sec = query(selector(heading.where(level: 1))).filter(it => (
          it.location().page() == loc.page()
        ))
        // else, we will seek for sections before this page
        let last_sec = query(selector(heading.where(level: 1)).before(loc))
        if cur_sec.len() > 0 {
          headerfunc(info.short-title, cur_sec.last().body)
        } else if last_sec.len() > 0 {
          headerfunc(info.short-title, last_sec.last().body)
        }
      } else { }
    },
  )
  it
}

#let config-equation(
  block-below: 8pt,
  block-above: 9pt,
  numbering: "(1.1.1.a)",
) = it => {
  show math.equation: set block(
    below: block-below,
    above: block-above,
  )
  set math.equation(
    numbering: (..eq-nums) => {
      let heading-nums = counter(heading).get()
      while heading-nums.len() < 2 {
        heading-nums.push(0)
      }
      heading-nums = heading-nums.slice(0, 2)
      std.numbering(numbering, ..heading-nums, ..eq-nums)
    },
  )
  it
}

#let config-common(
  author: none,
  date: none,
  keywords: none,
  publisher: none,
  lang: none,
  region: none,
  short-title: none,
  title: none,
  paper: none,
) = {
  let info = (
    author: author,
    date: date,
    keywords: keywords,
    lang: lang,
    region: region,
    publisher: publisher,
    title: title,
    short-title: short-title,
  )
  return _fold-application((
    config-metadata(info: info),
    config-page-geometry(paper: paper),
    config-bibliography(),
    config-equation(),
    config-equation-counter-resetting(),
    config-enumitem(),
    config-heading(),
    config-page-footer(info: info),
    config-page-header(info: info),
    config-par(),
    config-lang(info: info),
    config-outlined(),
  ))
}

#let config-front-matter() = body => {
  set page(numbering: "i")
  set heading(numbering: none)
  body
}
#let config-main-matter() = body => {
  set page(numbering: "1")
  body
}
#let config-appendix() = body => {
  counter(heading).update(0)
  body
}
#let config-back-matter() = body => {
  set heading(numbering: none)
  body
}
