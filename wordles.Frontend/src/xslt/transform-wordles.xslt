<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	exclude-result-prefixes="str"
>

	<!-- Import the `str:split()` function -->
	<xsl:import href="str-split.xslt" />

	<xsl:output method="html" indent="yes" omit-xml-declaration="yes" encoding="utf-8" />

	<xsl:template match="wordles">
		<xsl:apply-templates select="wordle">
			<xsl:sort select="@date" order="descending" />
		</xsl:apply-templates>
		<hr />
		<xsl:apply-templates select="wørdle">
			<xsl:sort select="@date" order="descending" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="wordle | wørdle">
		<div class="game-panel">
			<xsl:apply-templates select="try" />
			<xsl:if test="count(try) = 6 and @score = 0">
				<xsl:call-template name="solution">
					<xsl:with-param name="solution" select="@word" />
					<xsl:with-param name="letters" select="str:split(@word, '')" />
					<xsl:with-param name="control-row" select="true()" />
				</xsl:call-template>
			</xsl:if>
			<xsl:call-template name="fillers">
				<xsl:with-param name="count" select="6 - count(try)" />
			</xsl:call-template>
		</div>
	</xsl:template>

	<xsl:template match="try" name="solution">
		<xsl:param name="letters" select="str:split(., '')" />
		<xsl:param name="control-row" select="false()" />
		<xsl:param name="solution" select="../@word" />

		<div class="guess">
			<xsl:if test="$control-row">
				<xsl:attribute name="class">guess solution</xsl:attribute>
			</xsl:if>
			<xsl:for-each select="$letters">
				<xsl:variable name="index" select="position()" />
				<span class="wrong tile">
					<xsl:choose>
						<xsl:when test="substring($solution, $index, 1) = .">
							<xsl:attribute name="class">correct tile</xsl:attribute>
						</xsl:when>
						<xsl:when test="contains($solution, .)">
							<xsl:attribute name="class">ok tile</xsl:attribute>
						</xsl:when>
					</xsl:choose>
					<!-- Workaround for some encoding issues -->
					<!-- <xsl:value-of select="translate(current(), '0', 'ø')" /> -->
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


</xsl:stylesheet>
