
# Wordles

This is just my own log of [WORDLE][] solves (or fails, if any).

## ⚠️ SPOILER ALERT ⚠️

I should say that my log (obviously) contains the solutions to any wordle I've
solved, so don't look in any of the `wordle*.xml` in the `xml` folder, if you
don't want to accidentally be told the answer to any of these.

## Usage/rendering

There are two data files - one for the official [Wordle][WORDLE] ([wordle-official.xml](wordles.Frontend/src/xml/wordle-official.xml)) and one for the
Danish rip-off [Wørdle][WØRDLE] ([wordle-dk.xml](wordles.Frontend/src/xml/wordle-dk.xml)).

For rendering, both of these are included (via _XInclude_) in the main
[wordles.xml](wordles.Frontend/src/xml/wordles.xml) file that should be transformed
by the [transform-wordles.xslt](wordles.Frontend/src/xslt/transform-wordles.xslt) XSLT file.




[WORDLE]: https://www.powerlanguage.co.uk/wordle/
[WØRDLE]: https://www.wørdle.dk/


