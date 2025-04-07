#import "@preview/splash:0.3.0": tailwind

#import "notebook.typ": (
  notebook,
  config-notebook,
  config-structured-notebook,
)
#import "utils.typ": evals, _fold-application
#import "title-page.typ": make-title-page
#import "stateful.typ": (
  meta-info,
  outline-page,
  chapter-pages,
)
#import "title-page.typ": make-title-page, _title-page-exist

#import "theorems/exports.typ" as theorems
