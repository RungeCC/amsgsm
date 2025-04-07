#let title-function = (
  title,
  author,
  date,
  publisher: "RUNGE'S NOTEBOOK",
  alignment: center,
  datestyle: auto,
  thetext: (..args) => text(
    font: "New Computer Modern Sans",
    ..args,
  ),
  ..kwargs,
) => page(margin: (y: 0in, left: 8em))[#{
    v(5em, weak: false)
    align(
      left,
      {
        v(10em, weak: false)
        par(
          leading: 1.5em,
          thetext(
            size: 3.5em,
            weight: "bold",
            title,
          ),
        )
        v(4em, weak: true)
        thetext(
          size: 2.5em,
          author,
        )
        v(1fr)
        thetext(
          size: 2em,
          weight: "bold",
          publisher,
        )
        v(5em)
      },
    )
  }]
