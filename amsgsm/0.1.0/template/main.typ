#import "./configs/setups.typ": *
#import "./configs/prelude.typ": *
#import "contents/title.typ": title-function

#make-title-page(func: title-function)

#show: show-rules.common

#show: show-rules.front-matter

#include "./contents/preface.typ"

#outline(depth: 3)

#show: show-rules.main-matter.with(
  outer-configs: (
    heading-numbering-config(),
  ),
)

#include "./contents/ch1.typ"

#show: show-rules.appendix.with(
  outer-configs: (
    appendix-numbering-config(),
  ),
)

#include "./contents/postscript.typ"

#show: show-rules.back-matter

#make-bibliography("contents/ref.bib", full: true)

