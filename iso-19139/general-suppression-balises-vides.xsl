<?xml version="1.0" encoding="UTF-8"?>
<!--
  Doc: https://github.com/ecolabdata/ecospheres-xslt/blob/main/iso-19139/general-suppression-balises-vides.md
-->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                exclude-result-prefixes="#all">

  <xsl:output encoding="UTF-8"/>

  <!-- Entry point -->
  <xsl:template match="/">
    <xsl:call-template name="remove-empty">
      <xsl:with-param name="input" select="."/>
    </xsl:call-template>
  </xsl:template>

  <!-- Recursive cleanup template -->
  <xsl:template name="remove-empty">
    <xsl:param name="input"/>

    <xsl:variable name="pass">
      <xsl:apply-templates select="$input" mode="cleanup"/>
    </xsl:variable>

    <!-- Check if anything changed -->
    <xsl:choose>
      <xsl:when test="deep-equal($input, $pass)">
        <!-- No changes, we're done -->
        <xsl:copy-of select="$pass"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- Changes occurred, recurse -->
        <xsl:call-template name="remove-empty">
          <xsl:with-param name="input" select="$pass"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Remove empty elements -->
  <xsl:template match="*[not(normalize-space()) and not(*) and not(@*)]" mode="cleanup"/>

  <!-- Identity template -->
  <xsl:template match="@*|node()" mode="cleanup">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="cleanup"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
