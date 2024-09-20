<?xml version="1.0" encoding="UTF-8"?>
<!--
Sépare la licence des conditions d'accès

https://ecospheres.gitbook.io/recommandations-iso-dcat/adaptation-des-metadonnees-iso-19139-pour-faciliter-la-transformation-en-dcat/separer-la-licence-des-conditions-dacces
-->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                exclude-result-prefixes="#all">

  <!-- non-ambiguous OC = ACo + UCx + OC + UL? => ACo + OC / UCx + UL? -->
  <xsl:template match="gmd:resourceConstraints[gmd:MD_LegalConstraints[
                         gmd:accessConstraints/gmd:MD_RestrictionCode[@codeListValue = 'otherRestrictions']
                         and (gmd:useConstraints and
                              not(gmd:useConstraints/gmd:MD_RestrictionCode[@codeListValue = 'otherRestrictions']))
                         and gmd:otherConstraints
                       ]]">
    <!-- access constraints -->
    <xsl:call-template name="add-resource-constraint">
      <xsl:with-param name="constraints">
        <xsl:copy-of select="gmd:MD_LegalConstraints/gmd:accessConstraints"/>
        <xsl:copy-of select="gmd:MD_LegalConstraints/gmd:otherConstraints"/>
      </xsl:with-param>
    </xsl:call-template>
    <!-- use constraints -->
    <xsl:call-template name="add-resource-constraint">
      <xsl:with-param name="constraints">
        <xsl:copy-of select="gmd:MD_LegalConstraints/gmd:useLimitation"/>
        <xsl:copy-of select="gmd:MD_LegalConstraints/gmd:useConstraints"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- non-ambiguous OC = ACx + UCo + OC + UL? => noop -->
  <!-- no mapping for now, too many misclassifications -->
  
  <!-- special case of ambiguous OC = (ACo + UCo + 1OC + UL) | (ACx + UCx + 1OC + UL) => AC + OC / UC + UL -->
  <xsl:template match="gmd:resourceConstraints[gmd:MD_LegalConstraints[
                         (
                           (gmd:accessConstraints/gmd:MD_RestrictionCode[@codeListValue != 'otherRestrictions']
                            and (gmd:useConstraints[not(gmd:MD_RestrictionCode)]
                                 or gmd:useConstraints/gmd:MD_RestrictionCode[@codeListValue != 'otherRestrictions']))
                           or
                           (gmd:accessConstraints/gmd:MD_RestrictionCode[@codeListValue = 'otherRestrictions']
                            and gmd:useConstraints/gmd:MD_RestrictionCode[@codeListValue = 'otherRestrictions'])
                         )
                         and count(gmd:otherConstraints) = 1
                         and gmd:useLimitation
                       ]]">
    <!-- access constraints -->
    <xsl:call-template name="add-resource-constraint">
      <xsl:with-param name="constraints">
        <xsl:copy-of select="gmd:MD_LegalConstraints/gmd:accessConstraints"/>
        <xsl:copy-of select="gmd:MD_LegalConstraints/gmd:otherConstraints"/>
      </xsl:with-param>
    </xsl:call-template>
    <!-- use constraints -->
    <xsl:call-template name="add-resource-constraint">
      <xsl:with-param name="constraints">
        <xsl:copy-of select="gmd:MD_LegalConstraints/gmd:useLimitation"/>
        <xsl:copy-of select="gmd:MD_LegalConstraints/gmd:useConstraints"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="add-resource-constraint">
    <xsl:param name="constraints"/>
    <!-- copy gmd:resourceConstraints/gmd:MD_LegalConstraints as-is -->
    <gmd:resourceConstraints>
      <xsl:copy-of select="namespace::*"/>
      <xsl:copy-of select="@*"/>
      <gmd:MD_LegalConstraints>
        <xsl:copy-of select="gmd:MD_LegalConstraints/namespace::*"/>
        <xsl:copy-of select="gmd:MD_LegalConstraints/@*"/>
        <!-- copy constraints subtree as-is -->
        <xsl:copy-of select="$constraints"/>
      </gmd:MD_LegalConstraints>
    </gmd:resourceConstraints>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
