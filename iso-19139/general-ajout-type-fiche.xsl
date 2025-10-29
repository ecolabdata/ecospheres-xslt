<?xml version="1.0" encoding="UTF-8"?>
<!--
  Doc: https://github.com/ecolabdata/ecospheres-xslt/blob/main/iso-19139/general-ajout-type-fiche.md
-->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                exclude-result-prefixes="#all">

  <xsl:output encoding="UTF-8"/>

  <xsl:variable name="elementMissing" select="not(/gmd:MD_Metadata/gmd:hierarchyLevel)"/>
  <xsl:variable name="insertAfter" select="name(/gmd:MD_Metadata/*[name()='gmd:fileIdentifier' or name()='gmd:language'
                                           or name()='gmd:characterSet' or name()='gmd:parentIdentifier'][last()])"/>

  <xsl:template match="*[parent::gmd:MD_Metadata]">
    <xsl:call-template name="insert-default-hierarchy-level">
      <!-- FIXME: if first node is a comment, we insert before, possibly detaching comment from following node -->
      <xsl:with-param name="enabled" select="$elementMissing and not($insertAfter) and count(preceding-sibling::*) = 0"/>
    </xsl:call-template>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
    <xsl:call-template name="insert-default-hierarchy-level">
      <xsl:with-param name="enabled" select="$elementMissing and name() = $insertAfter"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="insert-default-hierarchy-level">
    <xsl:param name="enabled"/>
    <xsl:if test="$enabled">
      <gmd:hierarchyLevel>
        <gmd:MD_ScopeCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_ScopeCode" codeListValue="dataset"/>
      </gmd:hierarchyLevel>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
