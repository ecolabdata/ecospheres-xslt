<?xml version="1.0" encoding="UTF-8"?>
<!--
  Doc: https://github.com/ecolabdata/ecospheres-xslt/blob/main/iso-19139/contraintes-legales-separation-acces-utilisation.md
-->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="#all">

  <xsl:output encoding="UTF-8"/>

  <!-- Non-ambiguous OC: AC? + UC + OC[Anchor=LimitationsOnPublicAccess] + UL? => AC? + OC / UC + UL? -->
  <xsl:template priority="4"
                match="gmd:resourceConstraints[gmd:MD_LegalConstraints[
                         gmd:useConstraints
                         and gmd:otherConstraints
                         and count(gmd:otherConstraints) =
                           count(gmd:otherConstraints[gmx:Anchor[@xlink:href[
                             starts-with(., 'http://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess')
                           ]]])
                       ]]">
    <xsl:message>'otherConstraints' -> 'accessConstraints', car 'Anchor'="LimitationsOnPublicAccess".</xsl:message>
    <!-- access constraints -->
    <xsl:call-template name="add-resource-constraint">
      <xsl:with-param name="constraints">
        <xsl:choose>
          <xsl:when test="gmd:MD_LegalConstraints/gmd:accessConstraints">
            <xsl:copy-of select="gmd:MD_LegalConstraints/gmd:accessConstraints"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- create if missing -->
            <gmd:accessConstraints>
              <gmd:MD_RestrictionCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_RestrictionCode" codeListValue="otherRestrictions"/>
            </gmd:accessConstraints>
          </xsl:otherwise>
        </xsl:choose>
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

  <!-- Non-ambiguous OC: ACo + UCx + OC + UL? => ACo + OC / UCx + UL? -->
  <xsl:template priority="3"
                match="gmd:resourceConstraints[gmd:MD_LegalConstraints[
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

  <!-- Non-ambiguous OC: ACx + UCo + OC + UL? => ACx / UCo + OC + UL? -->
  <xsl:template priority="3"
                match="gmd:resourceConstraints[gmd:MD_LegalConstraints[
                         gmd:accessConstraints/gmd:MD_RestrictionCode[@codeListValue != 'otherRestrictions']
                         and gmd:useConstraints/gmd:MD_RestrictionCode[@codeListValue = 'otherRestrictions']
                         and gmd:otherConstraints
                       ]]">
    <xsl:message>[isomorphe:check] 'otherConstraints' -> 'useConstraints', mais souvent problématique.</xsl:message>
    <!-- access constraints -->
    <xsl:call-template name="add-resource-constraint">
      <xsl:with-param name="constraints">
        <xsl:copy-of select="gmd:MD_LegalConstraints/gmd:accessConstraints"/>
      </xsl:with-param>
    </xsl:call-template>
    <!-- use constraints -->
    <xsl:call-template name="add-resource-constraint">
      <xsl:with-param name="constraints">
        <xsl:copy-of select="gmd:MD_LegalConstraints/gmd:useLimitation"/>
        <xsl:copy-of select="gmd:MD_LegalConstraints/gmd:useConstraints"/>
        <xsl:copy-of select="gmd:MD_LegalConstraints/gmd:otherConstraints"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- Special case of ambiguous OC: (ACo + UCo + 1OC + UL) | (ACx + UCx + 1OC + UL) => AC + OC / UC + UL -->
  <xsl:template priority="3"
                match="gmd:resourceConstraints[gmd:MD_LegalConstraints[
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
    <xsl:message>[isomorphe:check] 'otherConstraints' -> 'accessConstraints', car présence de 'useLimitation'.</xsl:message>
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

  <xsl:template priority="2"
                match="gmd:resourceConstraints[gmd:MD_LegalConstraints[
                         gmd:accessConstraints
                         and gmd:useConstraints
                         and gmd:otherConstraints
                       ]]">
    <xsl:message>[isomorphe:check] 'otherConstraints' ambigu.</xsl:message>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
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
