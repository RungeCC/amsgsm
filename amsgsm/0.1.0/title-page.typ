#import "stateful.typ": (
  meta-info,
  _title-page-exist,
)

#let _default-title-page(
  title, // not short title!
  author,
  date,
  publisher: "RUNGE'S NOTEBOOK",
  alignment: center,
  datestyle: "at [year]/[month]/[day] [weekday repr:short]",
  ..style,
) = page(
  numbering: none,
  ..style,
)[
  #v(5em, weak: false)
  #align(
    alignment,
    {
      line(length: 100%)
      v(0.2em, weak: true)
      line(length: 100%)
      text(size: 30pt, weight: 700, title)
      line(length: 100%)
      v(0.2em, weak: true)
      line(length: 100%)
      v(2em, weak: true)
      text(size: 17pt, weight: 700, [By #author])
      v(1em, weak: true)
      text(
        size: 10pt,
        style: "italic",
        date.display(datestyle),
      )
      v(1fr)
      text(size: 17pt, weight: 700, publisher)
      v(2em)
    },
  )]

/// Make title page, handle internal `state` `__title-page-exist`
/// to make sure we only draw title page once
///
/// - args (any): extra arguments for making title page
/// - func (function): who actually create the title page
/// ->
#let make-title-page(
  ..args,
  func: _default-title-page,
  force: false,
) = (
  context if not _title-page-exist.get() or force {
    let fmeta = meta-info.final()
    func(
      fmeta.at("full-title"),
      fmeta.at("author"),
      fmeta.at("date"),
      publisher: fmeta.at("publisher"),
      ..args,
    )
    _title-page-exist.update(true)
  }
)

#let _add-title-page = (
  it => {
    make-title-page()
    it
  },
)
