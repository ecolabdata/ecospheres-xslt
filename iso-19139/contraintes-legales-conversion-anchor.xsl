<?xml version="1.0" encoding="UTF-8"?>
<!--
  Doc: https://github.com/ecolabdata/ecospheres-xslt/blob/main/iso-19139/contraintes-legales-conversion-anchor.md
-->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                extension-element-prefixes="exsl"
                exclude-result-prefixes="#all">

  <xsl:include href="../helpers.xsl"/>

  <xsl:output encoding="UTF-8"/>

  <!--
      Text-to-anchor mappings
  -->

  <!-- Licenses -->
  <xsl:variable name="licenses">
    <xsl:call-template name="build-registry-lookup">
      <xsl:with-param name="base-uri" select="'http://spdx.org/licenses'"/>
      <xsl:with-param name="entries">
        <!--
            Partly generated from:
            curl -s 'https://www.data.gouv.fr/api/1/datasets/licenses/' \
            | jq -r '.[] | select(.id=="lov2") | .title,.alternate_titles[],.url,.alternate_urls[] | "<alt>\(.)</alt>"'
        -->
        <item>
          <key>etalab-2.0</key>
          <label>Licence Ouverte / Open Licence version 2.0</label>
          <alt>Licence Ouverte / Open License version 2.0</alt>
          <alt>Licence Ouverte / Open Licence v2.0</alt>
          <alt>Licence Ouverte / Open License v2.0</alt>
          <alt>Licence Ouverte / Open Licence v2</alt>
          <alt>Licence Ouverte / Open License v2</alt>
          <alt>Licence Ouverte / Open Licence version 2.0</alt>
          <alt>Licence Ouverte / Open License version 2.0</alt>
          <alt>Licence Ouverte / Open Licence version 2</alt>
          <alt>Licence Ouverte / Open License version 2</alt>
          <alt>Licence Ouverte v2.0 (Etalab)</alt>
          <alt>License Ouverte v2.0 (Etalab)</alt>
          <alt>Licence Ouverte v2.0</alt>
          <alt>License Ouverte v2.0</alt>
          <alt>Licence Ouverte v2</alt>
          <alt>License Ouverte v2</alt>
          <alt>Licence Ouverte version 2.0</alt>
          <alt>License Ouverte version 2.0</alt>
          <alt>Licence Ouverte version 2</alt>
          <alt>License Ouverte version 2</alt>
          <alt>Licence Ouverte (Etalab)</alt>
          <alt>License Ouverte (Etalab)</alt>
          <alt>Licence Ouverte</alt>
          <alt>License Ouverte</alt>
          <alt>Licence Etalab v2.0</alt>
          <alt>License Etalab v2.0</alt>
          <alt>Licence Etalab v2</alt>
          <alt>License Etalab v2</alt>
          <alt>Licence Etalab version 2.0</alt>
          <alt>License Etalab version 2.0</alt>
          <alt>Licence Etalab version 2</alt>
          <alt>License Etalab version 2</alt>
          <alt>Licence Etalab</alt>
          <alt>License Etalab</alt>
          <alt>Open Licence v2.0</alt>
          <alt>Open License v2.0</alt>
          <alt>Open Licence v2</alt>
          <alt>Open License v2</alt>
          <alt>Open Licence version 2.0</alt>
          <alt>Open License version 2.0</alt>
          <alt>Open Licence version 2</alt>
          <alt>Open License version 2</alt>
          <alt>github.com/DISIC/politique-de-contribution-open-source/blob/master/LICENSE.pdf</alt>
          <alt>github.com/etalab/Licence-Ouverte/blob/master/LO.md</alt>
          <alt>raw.githubusercontent.com/DISIC/politique-de-contribution-open-source/master/LICENSE</alt>
          <alt>spdx.org/licenses/etalab-2.0.html</alt>
          <alt>spdx.org/licenses/etalab-2.0</alt>
          <alt>www.etalab.gouv.fr/licence-ouverte-open-licence</alt>
          <alt>www.etalab.gouv.fr/wp-content/uploads/2017/04/ETALAB-Licence-Ouverte-v2.0.pdf</alt>
          <alt>www.data.gouv.fr/Licence-Ouverte-Open-Licence</alt>
        </item>
        <item>
          <key>ODbL-1.0</key>
          <label>Open Data Commons Open Database License v1.0</label>
          <alt>Open Data Commons Open Database License (ODbL) 1.0</alt>
          <alt>Open Data Commons Open Database License (ODbL) v1.0</alt>
          <alt>Open Data Commons Open Database License (ODbL) version 1.0</alt>
          <alt>Open Data Commons Open Database License (ODbL)</alt>
          <alt>Open Data Commons Open Database License 1.0</alt>
          <alt>Open Data Commons Open Database License v1.0</alt>
          <alt>Open Data Commons Open Database License version 1.0</alt>
          <alt>Open Database License (ODbL) 1.0</alt>
          <alt>Open Database License (ODbL) v1.0</alt>
          <alt>Open Database License (ODbL) version 1.0</alt>
          <alt>Open Database License (ODbL)</alt>
          <alt>Open Database License</alt>
          <alt>opendatacommons.org/licenses/odbl/summary/</alt>
          <alt>www.opendatacommons.org/licenses/odbl/1.0/</alt>
          <alt>opendatacommons.org/licenses/odbl/1-0/</alt>
          <alt>opendefinition.org/licenses/odc-odbl</alt>
          <alt>spdx.org/licenses/ODbL-1.0.html</alt>
          <alt>spdx.org/licenses/ODbL-1.0</alt>
        </item>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>

  <!-- INSPIRE LimitationsOnPublicAccess -->
  <xsl:variable name="limitations">
    <xsl:call-template name="build-registry-lookup">
      <xsl:with-param name="base-uri" select="'http://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess'"/>
      <xsl:with-param name="entries">
        <item>
          <key>noLimitations</key>
          <label>Pas de restriction d'accès public</label>
          <alt>Pas de restriction d'accès publique</alt>
          <alt>Pas de restriction d'accès au public</alt>
          <alt>Pas de restriction d'accès public selon INSPIRE</alt>
          <alt>Directive 2007/2/CE (INSPIRE), pas de restriction d'accès public</alt>
        </item>
        <item>
          <key>INSPIRE_Directive_Article13_1a</key>
          <label>L124-4-I-1 du code de l'environnement (Directive 2007/2/CE (INSPIRE), Article 13.1.a)</label>
        </item>
        <item>
          <key>INSPIRE_Directive_Article13_1b</key>
          <label>L124-5-II-1 du code de l'environnement (Directive 2007/2/CE (INSPIRE), Article 13.1.b)</label>
        </item>
        <item>
          <key>INSPIRE_Directive_Article13_1c</key>
          <label>L124-5-II-2 du code de l'environnement (Directive 2007/2/CE (INSPIRE), Article 13.1.c)</label>
        </item>
        <item>
          <key>INSPIRE_Directive_Article13_1d</key>
          <label>L124-5-II-2 du code de l'environnement (Directive 2007/2/CE (INSPIRE), Article 13.1.c)</label>
        </item>
        <item>
          <key>INSPIRE_Directive_Article13_1e</key>
          <label>L124-5-II-3 du code de l'environnement (Directive 2007/2/CE (INSPIRE), Article 13.1.e)</label>
        </item>
        <item>
          <key>INSPIRE_Directive_Article13_1f</key>
          <label>L124-4-I-1 du code de l'environnement (Directive 2007/2/CE (INSPIRE), Article 13.1.f)</label>
        </item>
        <item>
          <key>INSPIRE_Directive_Article13_1g</key>
          <label>L124-4-I-3 du code de l'environnement (Directive 2007/2/CE (INSPIRE), Article 13.1.g)</label>
        </item>
        <item>
          <key>INSPIRE_Directive_Article13_1h</key>
          <label>L124-4-I-2 du code de l'environnement (Directive 2007/2/CE (INSPIRE), Article 13.1.h)</label>
        </item>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>

  <!-- INSPIRE ConditionsApplyingToAccessAndUse -->
  <xsl:variable name="conditions">
    <xsl:call-template name="build-registry-lookup">
      <xsl:with-param name="base-uri" select="'http://inspire.ec.europa.eu/metadata-codelist/ConditionsApplyingToAccessAndUse/noConditionsApply'"/>
      <xsl:with-param name="entries">
        <item>
          <key>noConditionsApply</key>
          <label>Aucune condition ne s'applique</label>
        </item>
        <item>
          <key>conditionsUnknown</key>
          <label>Conditions inconnues</label>
        </item>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>


  <!--
      Templates
  -->

  <xsl:template match="gmd:MD_LegalConstraints/gmd:otherConstraints">
    <xsl:variable name="label" select="gco:CharacterString"/>
    <xsl:variable name="license">
      <xsl:call-template name="as-constraint-anchor">
        <xsl:with-param name="lookup-table" select="$licenses"/>
        <xsl:with-param name="label" select="$label"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="limitation">
      <xsl:call-template name="as-constraint-anchor">
        <xsl:with-param name="lookup-table" select="$limitations"/>
        <xsl:with-param name="label" select="$label"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$license != ''">
        <xsl:copy-of select="$license"/>
      </xsl:when>
      <xsl:when test="$limitation != ''">
        <xsl:copy-of select="$limitation"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="as-constraint-anchor">
    <xsl:param name="lookup-table"/>
    <xsl:param name="label"/>
    <xsl:variable name="match">
      <xsl:call-template name="lookup-label">
        <xsl:with-param name="lookup-table" select="$lookup-table"/>
        <xsl:with-param name="label" select="$label"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="$match != ''">
      <gmd:otherConstraints>
        <xsl:copy-of select="namespace::*"/>
        <xsl:copy-of select="@*"/>
        <gmx:Anchor>
          <xsl:attribute name="xlink:href">
            <xsl:value-of select="exsl:node-set($match)/uri"/>
          </xsl:attribute>
          <xsl:value-of select="exsl:node-set($match)/label"/>
        </gmx:Anchor>
      </gmd:otherConstraints>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
