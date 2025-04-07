#import "@runge/notes:0.1.3": *
#import "./configs.typ": *

#let show-rules = config-structured-notebook(
  title: (
    long-title: [Yet Another \ Template for \ Maths Notes],
    short-title: "YANM",
  ),
  author: "Runge C.",
  date: datetime.today(),
  publisher: "PUBLISHER",
  locale: (
    language: "en",
    region: "US",
  ),
  draw-title-page: false,
  paper: "a4",
  inner-common-configs: (
    text-config,
    equation-config,
    equation-numbering-config,
    heading-config,
    outline-config,
    theorem-rules,
  ),
  outer-common-configs: (),
  applying-default-configs: true,
)
