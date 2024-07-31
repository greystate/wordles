
# Wordles

This is just my own log of [WORDLE][] solves (or fails, if any).

## ⚠️ SPOILER ALERT ⚠️

I should say that my log (obviously) contains the solutions to any wordle I've
solved, so don't look in any of the `*ordle*.xml` files in the `xml` folder, if
you don't want to accidentally be told the answer to any of these.

## Usage/rendering

There are three sets of data files - a set for the official [Wordle][WORDLE], a set for the
Danish rip-off [Wørdle][WØRDLE] and finally a set for the [Quordle][QUORDLE] variant where
you have 9 tries total to solve 4 separate wordles. For each set, there's a main file which
imports (via _XInclude_) a number of year-suffixed files.

For rendering, all of these are imported into the main
[wordles.xml](wordles.Frontend/src/xml/wordles.xml) file, which should be transformed
by the [transform-wordles.xslt](wordles.Frontend/src/xslt/transform-wordles.xslt) XSLT file which,
by default, renders the latest 6 Wordle & Wørdle solves, along with the latest 4 Quordle solves.
To render *everything*, set the `$showall` parameter to `true()` when invoking the transformation.




[WORDLE]: https://www.powerlanguage.co.uk/wordle/
[WØRDLE]: https://www.wørdle.dk/
[QUORDLE]: https://quordle.com/


