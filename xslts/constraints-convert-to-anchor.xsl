<?xml version="1.0" encoding="UTF-8"?>
<!--
Convertit le texte libre d'une otherRestrictions en gmx:Anchor lorsqu'il n'y a pas d'ambiguité.

https://ecospheres.gitbook.io/recommandations-iso-dcat/adaptation-des-metadonnees-iso-19139-pour-faciliter-la-transformation-en-dcat/faciliter-la-reconnaissance-des-licences
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

  <xsl:output encoding="UTF-8"/>

  <!--
      Text-to-anchor mappings
  -->

  <!-- Licenses -->
  <xsl:variable name="licenses">
    <xsl:call-template name="build-registry-lookup">
      <xsl:with-param name="base-uri" select="'https://spdx.org/licenses'"/>
      <xsl:with-param name="entries">
        <!--
            Partly generated from:
            curl -s 'https://www.data.gouv.fr/api/1/datasets/licenses/' \
            | jq -r '.[] | select(.id=="lov2") | .title,.alternate_titles[],.url,.alternate_urls[] | "<alt>\(.)</alt>"'
        -->
        <item>
          <key>etalab-2.0</key>
          <label>Licence Ouverte / Open Licence version 2.0</label>
          <alt>Licence Ouverte (Etalab)</alt>
          <alt>Licence Ouverte / Open Licence v2.0</alt>
          <alt>Licence Ouverte / Open Licence v2</alt>
          <alt>Licence Ouverte / Open Licence version 2.0</alt>
          <alt>Licence Ouverte / Open Licence version 2.0</alt>
          <alt>Licence Ouverte v2.0 (Etalab)</alt>
          <alt>Licence Ouverte v2.0</alt>
          <alt>Licence Ouverte v2</alt>
          <alt>Licence Ouverte version 2.0</alt>
          <alt>License Etalab v2.0</alt>
          <alt>License Etalab v2</alt>
          <alt>License Etalab version 2.0</alt>
          <alt>License Etalab</alt>
          <alt>License Ouverte</alt>
          <alt>Open Licence v2.0</alt>
          <alt>Open Licence v2</alt>
          <alt>Open Licence version 2.0</alt>
          <alt>https://github.com/DISIC/politique-de-contribution-open-source/blob/master/LICENSE.pdf</alt>
          <alt>https://github.com/etalab/Licence-Ouverte/blob/master/LO.md</alt>
          <alt>https://raw.githubusercontent.com/DISIC/politique-de-contribution-open-source/master/LICENSE</alt>
          <alt>https://spdx.org/licenses/etalab-2.0.html</alt>
          <alt>https://spdx.org/licenses/etalab-2.0</alt>
          <alt>https://www.etalab.gouv.fr/licence-ouverte-open-licence</alt>
          <alt>https://www.etalab.gouv.fr/wp-content/uploads/2017/04/ETALAB-Licence-Ouverte-v2.0.pdf</alt>
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
          <alt>http://opendatacommons.org/licenses/odbl/summary/</alt>
          <alt>http://www.opendatacommons.org/licenses/odbl/1.0/</alt>
          <alt>https://opendatacommons.org/licenses/odbl/1-0/</alt>
          <alt>https://opendefinition.org/licenses/odc-odbl</alt>
          <alt>https://spdx.org/licenses/ODbL-1.0.html</alt>
          <alt>https://spdx.org/licenses/ODbL-1.0</alt>
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


  <!--
      Helpers
  -->

  <xsl:template name="build-registry-lookup">
    <xsl:param name="entries"/>
    <xsl:param name="base-uri"/>

    <xsl:for-each select="exsl:node-set($entries)/item">
      <xsl:variable name="uri" select="concat($base-uri, '/', key)"/>
      <item>
        <alt>
          <xsl:call-template name="normalize-string">
            <xsl:with-param name="string" select="key"/>
          </xsl:call-template>
        </alt>
        <alt>
          <xsl:call-template name="normalize-string">
            <xsl:with-param name="string" select="$uri"/>
          </xsl:call-template>
        </alt>
        <alt>
          <xsl:call-template name="normalize-string">
            <xsl:with-param name="string" select="label"/>
          </xsl:call-template>
        </alt>
        <xsl:for-each select="alt">
          <alt>
            <xsl:call-template name="normalize-string">
              <xsl:with-param name="string" select="."/>
            </xsl:call-template>
          </alt>
        </xsl:for-each>
        <match>
          <uri><xsl:value-of select="$uri"/></uri>
          <xsl:copy-of select="label"/>
        </match>
      </item>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="lookup-label">
    <xsl:param name="lookup-table"/>
    <xsl:param name="label"/>

    <!-- full label -->
    <xsl:variable name="normalized">
      <xsl:call-template name="normalize-string">
        <xsl:with-param name="string" select="$label"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="match-full">
      <xsl:copy-of select="exsl:node-set($lookup-table)/item[alt=$normalized]/match/*"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$match-full != ''">
        <xsl:copy-of select="$match-full"/>
      </xsl:when>
      <xsl:otherwise>
      <!-- all but url -->
        <xsl:variable name="label-nourl" select="normalize-space(substring-before($normalized, 'http'))"/>
        <xsl:variable name="match-nourl">
          <xsl:copy-of select="exsl:node-set($lookup-table)/item[alt=$label-nourl]/match/*"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$match-nourl != ''">
            <xsl:copy-of select="$match-nourl"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- url -->
            <xsl:variable name="label-url" select="concat('http', substring-after($normalized, 'http'))"/>
            <xsl:variable name="match-url">
              <xsl:copy-of select="exsl:node-set($lookup-table)/item[alt=$label-url]/match/*"/>
            </xsl:variable>
              <xsl:if test="$match-url != ''">
                <xsl:copy-of select="$match-url"/>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="normalize-string">
    <xsl:param name="string"/>

    <xsl:variable name="accents_up">ÀÂÇÉÈÊËÎÏÔÙÛÜ</xsl:variable>
    <xsl:variable name="accents_lo">àâçéèêëîïôùûü</xsl:variable>
    <xsl:variable name="accents_tr">aaceeeeiiouuu</xsl:variable>

    <xsl:variable name="tr_from">’</xsl:variable>
    <xsl:variable name="tr_to"  >'</xsl:variable>

    <xsl:variable name="lowercase">
      <xsl:value-of select="translate($string,
                            concat('ABCDEFGHIJKLMNOPQRSTUVWXYZ', $accents_up),
                            concat('abcdefghijklmnopqrstuvwxyz', $accents_lo))"/>
    </xsl:variable>

    <xsl:variable name="folded">
      <xsl:value-of select="translate($lowercase,
                            concat($accents_lo, $tr_from),
                            concat($accents_tr, $tr_to))"/>
    </xsl:variable>

    <!-- normalize-space at the end in case we fold to space -->
    <xsl:value-of select="normalize-space($folded)"/>
  </xsl:template>

</xsl:stylesheet>
