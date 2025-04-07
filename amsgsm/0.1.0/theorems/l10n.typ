#import "utils/utils.typ": *

#let theorem-name-l10n(name, lang: "en_US") = {
  let l10n-data = toml("l10n/theorem-names.toml")
  l10n-data.at(lang).at(name)
}