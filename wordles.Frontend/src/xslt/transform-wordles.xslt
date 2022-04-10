<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	xmlns:w="http://xmlns.greystate.dk/2022/wordles"
	exclude-result-prefixes="w str"
>

	<!--
	Import an XSLT implementation of the the `str:split()` function,
	as the one in libxslt seems to bail on Danish the characters.
	-->
	<xsl:import href="str-split.xslt" />

	<xsl:key name="wordles-by-score" match="w:wordle" use="@score" />

	<xsl:output method="html" indent="yes" omit-xml-declaration="yes" encoding="utf-8" />

	<xsl:variable name="debugging" select="false()" />

	<xsl:template match="/">
		<h1>My WORDLE scores</h1>

		<xsl:apply-templates select="w:wordles" />

	</xsl:template>

	<xsl:template name="global-stats">
		<div>

		</div>
	</xsl:template>

	<xsl:template name="local-stats">
		<xsl:param name="wordles" select="/.." />
		<xsl:variable name="average" select="floor(sum($wordles/@score) div count($wordles))" />

<!-- 		<dl class="stats">
			<dt>Average score</dt>
			<dd><xsl:value-of select="$average" /></dd>
		</dl> -->
		<details>
			<summary>Stats</summary>
			<p>Number of guesses</p>
			<xsl:call-template name="score-bars">
				<xsl:with-param name="wordles" select="$wordles" />
				<xsl:with-param name="score" select="1" />
			</xsl:call-template>
		</details>

	</xsl:template>

	<xsl:template match="/w:wordles">
		<xsl:variable name="official-wordles" select="w:wordles[lang('en')]/w:wordle" />
		<xsl:variable name="danish-wordles" select="w:wordles[lang('da')]/w:wordle" />

		<h2>From the official Wordle</h2>
		<xsl:call-template name="local-stats">
			<xsl:with-param name="wordles" select="$official-wordles" />
		</xsl:call-template>
		<div lang="en">
			<xsl:apply-templates select="$official-wordles">
				<xsl:sort select="@date" order="descending" />
			</xsl:apply-templates>
		</div>

		<h2>From wørdle.dk</h2>
		<xsl:call-template name="local-stats" mode="local">
			<xsl:with-param name="wordles" select="$danish-wordles" />
		</xsl:call-template>
		<div style="--bgcolor-ok: #f80" lang="da">

			<xsl:apply-templates select="$danish-wordles">
				<xsl:sort select="@date" order="descending" />
			</xsl:apply-templates>
		</div>
	</xsl:template>

	<xsl:template match="w:wordle">
		<div class="hide game-panel">
			<header>
				<h3><xsl:value-of select="concat('#', @number)" /></h3>
			</header>
			<xsl:apply-templates select="w:try" />
			<xsl:if test="count(w:try) = 6 and @score = 0">
				<xsl:call-template name="solution">
					<xsl:with-param name="solution" select="@word" />
					<xsl:with-param name="letters" select="str:split(@word, '')" />
					<xsl:with-param name="control-row" select="true()" />
				</xsl:call-template>
			</xsl:if>
			<xsl:call-template name="fillers">
				<xsl:with-param name="count" select="6 - count(w:try)" />
			</xsl:call-template>
		</div>
	</xsl:template>

	<xsl:template match="w:try" name="solution">
		<xsl:param name="letters" select="str:split(., '')" />
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
						<!--
						The letter is in the solution but not in the correct position;
						AND the guess has the same number of copies of this letter
						-->
						<xsl:when test="contains($solution, .) and $diff &gt;= 0">
							<xsl:attribute name="class">ok tile</xsl:attribute>
						</xsl:when>
					</xsl:choose>
					<xsl:value-of select="current()" />
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
		<div class="guess">
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

		<xsl:call-template name="score-bar">
			<xsl:with-param name="wordles" select="$wordles" />
			<xsl:with-param name="score" select="$score" />
		</xsl:call-template>

		<xsl:if test="$score &lt; 6">
			<xsl:call-template name="score-bars">
				<xsl:with-param name="wordles" select="$wordles" />
				<xsl:with-param name="score" select="$score + 1" />
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
			<xsl:variable name="has-hi-value" select="$count &gt;= $max-count" />

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

</xsl:stylesheet>
