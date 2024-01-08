<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			<xsl:apply-templates select="* | text() | comment()" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="comment() | text()">
		<xsl:copy-of select="." />
	</xsl:template>

	<xsl:template match="@*">
		<xsl:copy-of select="." />
	</xsl:template>

	<xsl:template match="@number">
		<xsl:variable name="value" select="number(.)" />
		<xsl:attribute name="number">
			<xsl:choose>
				<!-- <xsl:when test="$value &gt;= 490 and $value &lt; 617">
					<xsl:value-of select="$value - 9" />
				</xsl:when> -->
				<xsl:when test="$value &gt;= 617 and $value &lt;= 680 and ../following-sibling::*[@number = 673]">
					<xsl:value-of select="$value - 8" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$value" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

</xsl:stylesheet>
