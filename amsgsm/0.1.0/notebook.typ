/// internal modules
#import "defaults.typ": (
  config-front-matter,
  config-main-matter,
  config-back-matter,
  config-appendix,
  config-common,
)
#import "title-page.typ": _add-title-page
#import "stateful.typ": (
  outline-page,
  chapter-pages,
  meta-info,
  _title-page-exist,
)
#import "utils.typ": *

#let _extract-titles(title) = {
  let _pick-title(arg) = {
    if type(arg) == dictionary {
      return arg.at("long-title")
    } else if type(arg) == str {
      arg
    } else {
      panic(arg + " shall be an `dictionary` or a `string`.")
    }
  }

  let _pick-short-title(arg) = {
    if type(arg) == dictionary {
      return arg.at("short-title")
    }
    none
  }

  let long-title = _pick-title(title)
  let full-title = if type(long-title) == content {
    long-title
  } else {
    _evalc(long-title)
  }
  let short-title = _pick-short-title(title)
  let normalized-title = if type(long-title) == str {
    long-title.replace("\n", "")
  } else {
    if type(long-title) == content {
      _content-to-str(long-title)
    } else {
      none
    }
  }
  let short-title = if _pick-short-title(title) == none {
    if normalized-title != none {
      normalized-title
    } else {
      "NONE!"
    }
  } else {
    short-title
  }
  return (full-title, short-title)
}

#let config-structured-notebook(
  title: "TITLE",
  author: "Runge",
  date: datetime.today(),
  locale: (
    language: "en",
    region: "US",
  ),
  publisher: "RUNGE'S NOTEBOOK", // str
  keywords: (),
  paper: "a4",
  draw-title-page: true,
  inner-common-configs: none, // array | none | auto
  outer-common-configs: none, // array | none | auto
  applying-default-configs: true,
) = {
  let (full-title, short-title) = _extract-titles(title)

  // this hook is quite fundamental, so will always be applied.
  let states-config = body => {
    // update metainfo
    meta-info.update((
      "author": author,
      "title": short-title,
      "full-title": full-title,
      "date": date,
      "publisher": publisher,
      "language": locale.language,
      "region": locale.region,
    ))
    show outline: it => {
      outline-page.update(it.location().page())
      it
    }
    show heading.where(level: 1): it => {
      chapter-pages.update(x => x + (it.location().page(),))
      it
    }
    body
  }

  let args = arguments(
    title: full-title,
    short-title: short-title,
    author: author,
    publisher: publisher,
    date: date,
    lang: locale.language,
    region: locale.region,
    paper: paper,
    keywords: keywords,
  )

  let default-configs = (
    config-common(..args),
  )

  let necessary-configs = (states-config,)

  if draw-title-page {
    necessary-configs = _add-title-page + necessary-configs
  }

  return (
    common: _rewrap-configs(
      default-configs: _rewrap-configs(default-configs: default-configs).with(
        inner-configs: inner-common-configs,
        outer-configs: outer-common-configs,
        applying-default-configs: applying-default-configs,
      ),
      necessary-configs: necessary-configs,
    ),
    front-matter: _rewrap-configs(default-configs: config-front-matter()),
    main-matter: _rewrap-configs(default-configs: config-main-matter()),
    back-matter: _rewrap-configs(default-configs: config-back-matter()),
    appendix: _rewrap-configs(default-configs: config-appendix()),
  )
}

#let config-notebook(
  ..args,
) = {
  let configs = config-structured-notebook(..args)
  return _combine-configs(configs.common, configs.main-matter)
}

#let notebook(
  body,
  ..args,
) = config-notebook(..args)(body)
