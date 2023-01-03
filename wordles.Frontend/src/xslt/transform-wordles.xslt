<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	xmlns:date="http://exslt.org/dates-and-times"
	xmlns:math="http://exslt.org/math"
	xmlns:make="http://exslt.org/common"
	xmlns:w="http://xmlns.greystate.dk/2022/wordles"
	exclude-result-prefixes="w str date"
>

	<xsl:key name="wordles-by-score" match="w:wordle" use="@score" />

	<xsl:output method="html" indent="yes" omit-xml-declaration="yes" encoding="utf-8" />

	<xsl:param name="showall" select="false()" />
	<xsl:param name="debugging" select="false()" />

	<xsl:variable name="max-wordles" select="6" />
	<xsl:variable name="max-quordles" select="4" />

	<xsl:variable name="today" select="substring(date:date(), 1, 10)" />

	<xsl:attribute-set name="identification">
		<xsl:attribute name="id"><xsl:value-of select="concat(substring(local-name(), 1, 1), '-', ancestor::w:wordles/@xml:lang, '-', @number)" /></xsl:attribute>
	</xsl:attribute-set>

	<xsl:template match="/">
		<h1>My WORDLE scores</h1>
		<xsl:apply-templates select="w:wordles" />
	</xsl:template>

	<xsl:template name="global-stats">
		<div>

		</div>
	</xsl:template>

	<xsl:template name="longest-streak-wordle">
		<xsl:param name="wordles" select="/.." />
		<xsl:variable name="start" select="$wordles[1]/@number" />
		<xsl:variable name="current" select="$wordles[last()]" />
		<xsl:variable name="streaks-RTF">
			<xsl:for-each select="$wordles[@score = 0] | $current">
				<xsl:variable name="previous" select="preceding-sibling::w:wordle[@score = 0][1]" />
				<xsl:variable name="streak" select="@number - ($previous/@number + 1)" />
				<xsl:choose>
					<xsl:when test="string($streak) = 'NaN'">
						<streak length="{@number - $start}" number="{@number}" />
					</xsl:when>
					<xsl:when test="@number = $current/@number and not(@score = 0)">
						<streak length="{@number - $previous/@number}" number="{@number}" />
					</xsl:when>
					<xsl:otherwise>
						<streak length="{$streak}" number="{@number}" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="streaks" select="make:node-set($streaks-RTF)" />
		<xsl:value-of select="math:max($streaks/streak/@length)" />
	</xsl:template>

	<xsl:template name="longest-streak-quordle">
		<xsl:param name="wordles" select="/.." />
		<xsl:variable name="start" select="$wordles[1]/@number" />
		<xsl:variable name="current" select="$wordles[last()]" />
		<xsl:variable name="streaks-RTF">
			<xsl:for-each select="$wordles[contains(@scores, 0)] | $current">
				<xsl:variable name="previous" select="preceding-sibling::w:quordle[contains(@scores, 0)][1]" />
				<xsl:variable name="streak" select="@number - ($previous/@number + 1)" />
				<xsl:choose>
					<xsl:when test="string($streak) = 'NaN'">
						<streak length="{@number - $start}" number="{@number}" />
					</xsl:when>
					<xsl:when test="@number = $current/@number and not(contains(@scores, 0))">
						<streak length="{@number - $previous/@number}" number="{@number}" />
					</xsl:when>
					<xsl:otherwise>
						<streak length="{$streak}" number="{@number}" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="streaks" select="make:node-set($streaks-RTF)" />
		<xsl:value-of select="math:max($streaks/streak/@length)" />
	</xsl:template>

	<xsl:template name="local-stats">
		<xsl:param name="wordles" select="/.." />
		<xsl:param name="end-score" select="6" />
		<xsl:variable name="average" select="floor(sum($wordles/@score) div count($wordles))" />

		<xsl:variable name="current" select="$wordles[last()]" />
		<xsl:variable name="latest-lost" select="$current/preceding-sibling::w:wordle[@score = 0][1]" />

		<details>
			<summary>Stats</summary>
			<div class="stats-content">
				<div>
					<h3>Number of guesses</h3>
					<xsl:call-template name="score-bars">
						<xsl:with-param name="wordles" select="$wordles" />
						<xsl:with-param name="score" select="1" />
						<xsl:with-param name="end-score" select="$end-score" />
					</xsl:call-template>
				</div>

				<div>
					<h3>Wins &amp; streaks</h3>
					<table border="1">
						<tr>
							<th scope="row">Wins</th>
							<td>
								<xsl:value-of select="round(count($wordles[not(@score = 0)]) div (count($wordles)) * 100)" />
								<xsl:text>%</xsl:text>
							</td>
						</tr>
						<tr>
							<th scope="row">Current streak</th>
							<td>
								<xsl:value-of select="$current/@number - $latest-lost/@number" />
							</td>
						</tr>
						<tr>
							<th scope="row">Longest streak</th>
							<td>
								<xsl:call-template name="longest-streak-wordle">
									<xsl:with-param name="wordles" select="$wordles" />
								</xsl:call-template>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</details>

	</xsl:template>

	<xsl:template match="/w:wordles">
		<xsl:variable name="official-wordles" select="w:wordles[lang('en')]/w:wordle" />
		<xsl:variable name="danish-wordles" select="w:wordles[lang('da')]/w:wordle" />
		<xsl:variable name="quordles" select="w:wordles[w:quordle]/w:quordle" />

		<h2>From the official Wordle</h2>
		<xsl:call-template name="local-stats">
			<xsl:with-param name="wordles" select="$official-wordles" />
		</xsl:call-template>
		<div lang="en">
			<xsl:for-each select="$official-wordles">
				<xsl:sort select="@date" order="descending" />
				<xsl:if test="position() &lt;= $max-wordles or $showall = 'yes'">
					<xsl:apply-templates select="." />
				</xsl:if>
			</xsl:for-each>
		</div>

		<h2>From wørdle.dk</h2>
		<xsl:call-template name="local-stats">
			<xsl:with-param name="wordles" select="$danish-wordles" />
		</xsl:call-template>
		<div style="--bgcolor-ok: #f80" lang="da">
			<xsl:for-each select="$danish-wordles">
				<xsl:sort select="@date" order="descending" />
				<xsl:if test="position() &lt;= $max-wordles or $showall = 'yes'">
					<xsl:apply-templates select="." />
				</xsl:if>
			</xsl:for-each>
		</div>

		<h2>Quordle</h2>
		<details>
			<summary>Stats</summary>
			<div class="stats-content">
				<xsl:variable name="current" select="$quordles[last()]" />
				<xsl:variable name="latest-lost" select="$current/preceding-sibling::w:quordle[contains(@scores, 0)][1]" />

				<div>
					<h3>Wins &amp; streaks</h3>
					<table border="1">
						<tr>
							<th scope="row">Wins</th>
							<td>
								<xsl:value-of select="round(count($quordles[not(contains(@scores, 0))]) div (count($quordles)) * 100)" />
								<xsl:text>%</xsl:text>
							</td>
						</tr>
						<tr>
							<th scope="row">Current streak</th>
							<td>
								<xsl:value-of select="$current/@number - $latest-lost/@number" />
							</td>
						</tr>
						<tr>
							<th scope="row">Longest streak</th>
							<td>
								<xsl:call-template name="longest-streak-quordle">
									<xsl:with-param name="wordles" select="$quordles" />
								</xsl:call-template>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</details>


		<div style="--col-size: 14rem;" lang="en">
			<xsl:for-each select="$quordles">
				<xsl:sort select="@date" order="descending" />
				<xsl:if test="position() &lt;= $max-quordles or $showall = 'yes'">
					<div class="quad-panel hide" xsl:use-attribute-sets="identification">
						<xsl:if test="@date = $today">
							<xsl:attribute name="class">quad-panel hide today</xsl:attribute>
						</xsl:if>
						<header><h3 title="{@date}"><xsl:value-of select="concat('#', @number)" /></h3></header>
						<xsl:apply-templates select="." mode="scores" />
						<xsl:apply-templates select="." mode="panels" />
					</div>
				</xsl:if>
			</xsl:for-each>
		</div>

	</xsl:template>

	<xsl:template match="w:wordle">
		<div class="hide game-panel" xsl:use-attribute-sets="identification">
			<xsl:if test="@date = $today">
				<xsl:attribute name="class">hide game-panel today</xsl:attribute>
			</xsl:if>
			<header>
				<h3 title="{@date}"><xsl:value-of select="concat('#', @number)" /></h3>
			</header>
			<xsl:apply-templates select="w:try" />
			<xsl:if test="count(w:try) = 6 and @score = 0">
				<xsl:call-template name="solution">
					<xsl:with-param name="solution" select="@word" />
					<xsl:with-param name="letters" select="str:tokenize(@word, '')" />
					<xsl:with-param name="control-row" select="true()" />
				</xsl:call-template>
			</xsl:if>
			<xsl:call-template name="fillers">
				<xsl:with-param name="count" select="6 - count(w:try)" />
			</xsl:call-template>
		</div>
	</xsl:template>

	<xsl:template match="w:quordle" mode="scores">
		<xsl:param name="scores" select="str:tokenize(@scores, ' ')" />
		<xsl:param name="words" select="str:tokenize(@words, ' ')" />
		<div class="quadscore">
			<dl class="scores">
				<xsl:for-each select="$words">
					<xsl:variable name="pos" select="position()" />
					<xsl:variable name="score" select="$scores[$pos]" />
					<dt class="correct">
						<xsl:if test="$score = 0"><xsl:attribute name="class">wrong</xsl:attribute></xsl:if>
						<xsl:value-of select="." />
					</dt>
					<dd><xsl:value-of select="$score" /></dd>
				</xsl:for-each>
			</dl>
		</div>
	</xsl:template>

	<xsl:template match="w:try" name="solution">
		<xsl:param name="letters" select="str:tokenize(., '')" />
		<xsl:param name="control-row" select="false()" />
		<xsl:param name="solution" select="../@word" />

		<xsl:variable name="guess" select="." />

		<div class="guess">
			<xsl:if test="$control-row">
				<xsl:attribute name="class">guess solution</xsl:attribute>
			</xsl:if>
			<xsl:for-each select="$letters">
				<xsl:variable name="index" select="position()" />
				<xsl:variable name="diff" select="string-length(translate($guess, ., '')) - string-length(translate($solution, ., ''))" />

				<span class="wrong tile">
					<xsl:if test="$debugging">
						<xsl:attribute name="data-diff"><xsl:value-of select="$diff" /></xsl:attribute>
					</xsl:if>
					<xsl:choose>
						<!-- The letter is in the correct position -->
						<xsl:when test="substring($solution, $index, 1) = .">
							<xsl:attribute name="class">correct tile</xsl:attribute>
						</xsl:when>

						<!-- The letter is in the solution though... -->
						<xsl:when test="contains($solution, .)">

							<xsl:choose>
								<!--
								Same number of copies of the letter;
								OR the solution has more copies of this letter than the guess -->
								<xsl:when test="$diff &gt;= 0">
									<xsl:attribute name="class">ok tile</xsl:attribute>
								</xsl:when>

								<!-- Guess has one more copy of this letter than the solution -->
								<xsl:when test="$diff = -1">
									<xsl:variable name="pos1" select="string-length(substring-before($guess, .)) + 1" />
									<xsl:variable name="pos2" select="string-length(substring-before(substring($guess, $pos1 + 1), .)) + 1 + $pos1" />

									<!-- This is the first, though -->
									<xsl:if test="$index = $pos1">
										<!-- If the other one isn't 'correct', this one should be marked 'ok' -->
										<xsl:if test="not(substring($solution, $pos2, 1) = .)">
											<xsl:attribute name="class">ok tile</xsl:attribute>
										</xsl:if>
									</xsl:if>
								</xsl:when>

								<!-- Guess has two or more copies of this same letter -->
								<xsl:when test="$diff &lt; -1">
									<xsl:variable name="pos1" select="string-length(substring-before($guess, .)) + 1" />
									<xsl:variable name="pos2" select="string-length(substring-before(substring($guess, $pos1 + 1), .)) + 1 + $pos1" />
									<xsl:variable name="pos3" select="string-length(substring-before(substring($guess, $pos2 + 1), .)) + 1 + $pos2" />

									<!-- This is the first, though -->
									<xsl:if test="$index = $pos1">
										<!-- If the others aren't 'correct', this one should be marked 'ok' -->
										<xsl:if test="not(substring($solution, $pos2, 1) = .) and not(substring($solution, $pos3, 1) = .)">
											<xsl:attribute name="class">ok tile</xsl:attribute>
										</xsl:if>
									</xsl:if>

								</xsl:when>

								<!-- We didn't anticipate this scenario! -->
								<xsl:otherwise>
									<xsl:attribute name="class">tile unknown</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>

					</xsl:choose>
					<xsl:value-of select="." />
				</span>
			</xsl:for-each>
		</div>
	</xsl:template>

	<xsl:template name="fillers">
		<xsl:param name="count" select="5" />
		<xsl:if test="$count >= 1">
			<xsl:call-template name="blank-guess" />
			<xsl:call-template name="fillers">
				<xsl:with-param name="count" select="$count - 1" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="blank-guess">
		<div class="filler guess">
			<span class="tile"></span>
			<span class="tile"></span>
			<span class="tile"></span>
			<span class="tile"></span>
			<span class="tile"></span>
		</div>
	</xsl:template>

	<xsl:template name="score-bars">
		<xsl:param name="wordles" select="/.." />
		<xsl:param name="score" select="1" />
		<xsl:param name="end-score" select="6" />

		<xsl:call-template name="score-bar">
			<xsl:with-param name="wordles" select="$wordles" />
			<xsl:with-param name="score" select="$score" />
		</xsl:call-template>

		<xsl:if test="$score &lt; $end-score">
			<xsl:call-template name="score-bars">
				<xsl:with-param name="wordles" select="$wordles" />
				<xsl:with-param name="score" select="$score + 1" />
				<xsl:with-param name="end-score" select="$end-score" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="score-bar">
		<xsl:param name="wordles" select="/.." />
		<xsl:param name="score" select="1" />
		<xsl:variable name="lang" select="$wordles[1]/ancestor::w:wordles[1]/@xml:lang" />

		<xsl:if test="$wordles">
			<!-- Get the number of wordles solved in `$score` attempts -->
			<xsl:variable name="count" select="count(key('wordles-by-score', $score)[lang($lang)])" />
			<!-- Now find the highest number of attempts -->
			<xsl:variable name="max-count">
				<xsl:for-each select="$wordles">
					<xsl:sort select="count(key('wordles-by-score', ./@score)[lang($lang)])" data-type="number" order="descending" />
					<xsl:if test="position() = 1">
						<xsl:variable name="max-score" select="@score" />
						<xsl:value-of select="count($wordles[@score = $max-score])" />
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>

			<xsl:variable name="hilite" select="count($wordles[@score = $score]) = $max-count" />
			<xsl:variable name="has-hi-value" select="$count &gt;= ($max-count * 0.8)" />

			<dl class="scorebar" data-hi="{$hilite}">
				<xsl:if test="$has-hi-value">
					<xsl:attribute name="class">scorebar hi-value</xsl:attribute>
				</xsl:if>
				<xsl:if test="$hilite">
					<xsl:attribute name="class">
						<xsl:text>scorebar hilite</xsl:text>
						<xsl:if test="$has-hi-value"> hi-value</xsl:if>
					</xsl:attribute>
				</xsl:if>
				<dt><xsl:value-of select="$score" /></dt>
				<dd><meter min="0" max="{$max-count}" value="{$count}"><xsl:value-of select="$count" /></meter></dd>
			</dl>
		</xsl:if>
	</xsl:template>

	<xsl:template match="w:quordle" mode="panels">
		<xsl:variable name="score1" select="substring(@scores, 1, 1)" />
		<xsl:variable name="score2" select="substring(@scores, 3, 1)" />
		<xsl:variable name="score3" select="substring(@scores, 5, 1)" />
		<xsl:variable name="score4" select="substring(@scores, 7, 1)" />

		<xsl:call-template name="quordle-panel">
			<xsl:with-param name="quadrant" select="1" />
		</xsl:call-template>

		<xsl:call-template name="quordle-panel">
			<xsl:with-param name="quadrant" select="2" />
		</xsl:call-template>

		<xsl:call-template name="quordle-panel">
			<xsl:with-param name="quadrant" select="3" />
		</xsl:call-template>

		<xsl:call-template name="quordle-panel">
			<xsl:with-param name="quadrant" select="4" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="quordle-panel">
		<xsl:param name="quordle" select="." />
		<xsl:param name="quadrant" select="1" />
		<xsl:param name="score" select="substring($quordle/@scores, $quadrant * 2 - 1, 1)" />
		<xsl:param name="solution" select="substring($quordle/@words, 1 + 6 * ($quadrant - 1), 5)" />

		<div class="game-panel">
			<xsl:apply-templates select="$quordle/w:try[position() &lt;= $score]">
				<xsl:with-param name="solution" select="$solution" />
			</xsl:apply-templates>
			<xsl:if test="$score = 0">
				<xsl:apply-templates select="$quordle/w:try">
					<xsl:with-param name="solution" select="$solution" />
				</xsl:apply-templates>
				<xsl:if test="count($quordle/w:try) = 0">
					<xsl:call-template name="fillers">
						<xsl:with-param name="count" select="9" />
					</xsl:call-template>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$score &gt; 0">
				<xsl:call-template name="fillers">
					<xsl:with-param name="count" select="9 - $score" />
				</xsl:call-template>
			</xsl:if>
		</div>
	</xsl:template>

</xsl:stylesheet>
