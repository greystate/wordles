
# Wordles

This is just my own log of [WORDLE][] solves (or fails, if any).

## ⚠️ SPOILER ALERT ⚠️

I should say that my log (obviously) contains the solutions to any wordle I've
solved, so don't look in any of the `*ordle*.xml` files in the `xml` folder, if
you don't want to accidentally be told the answer to any of these.

## Usage/rendering

There are three data files - one for the official [Wordle][WORDLE] ([wordle-official.xml](wordles.Frontend/src/xml/wordle-official.xml)), one for the
Danish rip-off [Wørdle][WØRDLE] ([wordle-dk.xml](wordles.Frontend/src/xml/wordle-dk.xml)) and
finally one for the [Quordle][QUORDLE] ([quordle](wordles.Frontend/src/xml/quordle.xml)) variant where
you have 9 tries total to solve 4 separate wordles.

For rendering, all of these are included (via _XInclude_) in the main
[wordles.xml](wordles.Frontend/src/xml/wordles.xml) file that should be transformed
by the [transform-wordles.xslt](wordles.Frontend/src/xslt/transform-wordles.xslt) XSLT file which,
by default, renders the latest 6 Wordle & Wørdle solves, along with the latest 4 Quordle solves.
To render *everything*, set the `$showall` parameter to `true()` when invoking the transformation.




[WORDLE]: https://www.powerlanguage.co.uk/wordle/
[WØRDLE]: https://www.wørdle.dk/
[QUORDLE]: https://quordle.com/


