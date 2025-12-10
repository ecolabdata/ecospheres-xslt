<?xml version="1.0" encoding="UTF-8"?>
<!--
  Doc: https://github.com/ecolabdata/ecospheres-xslt/blob/main/iso-19139/distributions-ajout-parametres-ogc.md
-->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                exclude-result-prefixes="#all">

  <xsl:output encoding="UTF-8"/>

  <xsl:param name="ogc-protocols" select="'wfs, wms'"/>
  <xsl:param name="override-existing" select="'no'"/>

  <xsl:variable name="protocols" select="for $p in tokenize($ogc-protocols, ',') return lower-case(normalize-space($p))"/>


  <!-- Match a distribution URL when its protocol matches one of our targets -->
  <xsl:template match="gmd:CI_OnlineResource[some $p in $protocols satisfies
                         starts-with(lower-case(gmd:protocol/gco:CharacterString), concat('ogc:', $p))
                       ]/gmd:linkage/gmd:URL">

    <xsl:variable name="protocol" select="lower-case(ancestor::gmd:CI_OnlineResource/gmd:protocol/gco:CharacterString)"/>
    <xsl:variable name="service" select="($protocols[starts-with($protocol, concat('ogc:', .))])[1]"/>

    <xsl:copy>
      <xsl:call-template name="add-ogc-params">
        <xsl:with-param name="url" select="."/>
        <xsl:with-param name="service" select="$service"/>
        <xsl:with-param name="override" select="lower-case($override-existing) = 'yes'"/>
      </xsl:call-template>
    </xsl:copy>
  </xsl:template>


  <!-- Add missing OGC parameters to an URL -->
  <xsl:template name="add-ogc-params">
    <xsl:param name="url"/>
    <xsl:param name="service"/>
    <xsl:param name="override"/>

    <xsl:variable name="base-url" select="if (contains($url, '?')) then substring-before($url, '?') else $url"/>
    <xsl:variable name="query-string" select="substring-after($url, '?')"/>

    <!-- exclude request/service from base params in override mode, otherwise keep them -->
    <xsl:variable name="base-params"
                  select="if ($override)
                          then tokenize($query-string, '&amp;')[not(matches(., '^(request|service)=', 'i'))]
                          else tokenize($query-string, '&amp;')"/>

    <xsl:variable name="has-service" select="not($override) and (some $p in $base-params satisfies matches($p, '^service=', 'i'))"/>
    <xsl:variable name="has-request" select="not($override) and (some $p in $base-params satisfies matches($p, '^request=', 'i'))"/>

    <!-- select automagically flattens enumerations, so "string*, string, string" -> string* -->
    <xsl:variable name="params"
                  select="$base-params,
                          if (not($has-service)) then concat('service=', upper-case($service)) else (),
                          if (not($has-request)) then 'request=GetCapabilities' else ()"/>

    <xsl:value-of select="concat($base-url, '?', string-join($params, '&amp;'))"/>
  </xsl:template>


  <!-- Identity template -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
