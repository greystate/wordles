<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	exclude-result-prefixes="str"
>

	<xsl:output method="html" indent="yes" omit-xml-declaration="yes" />

	<xsl:template match="wordles">
		<xsl:apply-templates select="wordle" />
		<hr />
		<xsl:apply-templates select="wørdle" />
	</xsl:template>

	<xsl:template match="wordle | wørdle">
		<div class="game-panel">
			<xsl:apply-templates select="try" />
			<xsl:for-each select="str:split('******', '')">

			</xsl:for-each>
		</div>
	</xsl:template>

	<xsl:template match="try">
		<xsl:variable name="solution" select="../@word" />
		<xsl:variable name="letters" select="str:split(., '')" />

		<div class="guess">
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
					<xsl:value-of select="current()" />
				</span>
			</xsl:for-each>
		</div>
	</xsl:template>


</xsl:stylesheet>
