/// in this module, we introduce some statefule variables and related utilities

#let outline-page = state("content-page", 9999)

#let meta-info = state(
  "metainfo",
  (
    "author": "G.W.F. Hegel",
    "title": "Phänomenologie des Geistes",
    "date": datetime(year: 1807, month: 1, day: 1),
    "publisher": "Bamberg und Würzburg",
    "language": "en",
    "region": "US",
  ),
)

#let chapter-pages = state("chapter-page", ())

#let _title-page-exist = state("title-page-exist", false)


