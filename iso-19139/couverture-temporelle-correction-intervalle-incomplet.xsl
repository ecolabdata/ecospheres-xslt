<?xml version="1.0" encoding="UTF-8"?>
<!--
  Doc: https://github.com/ecolabdata/ecospheres-xslt/blob/main/iso-19139/couverture-temporelle-correction-intervalle-incomplet.md
-->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                exclude-result-prefixes="#all">

  <xsl:output encoding="UTF-8"/>

  <xsl:template match="gml:TimePeriod[not(gml:begin or gml:beginPosition)]/*">
    <xsl:if test="name()='gml:end' or name()='gml:endPosition'">
      <gml:beginPosition indeterminatePosition="unknown"/>
    </xsl:if>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="gml:TimePeriod[not(gml:end or gml:endPosition)]/*">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
    <xsl:if test="name()='gml:begin' or name()='gml:beginPosition'">
      <gml:endPosition indeterminatePosition="unknown"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
