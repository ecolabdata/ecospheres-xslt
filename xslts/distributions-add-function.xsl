<?xml version="1.0" encoding="UTF-8"?>
<!--
  Doc: https://github.com/ecolabdata/ecospheres-xslt/blob/main/xslts/distributions-add-function.md
-->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                exclude-result-prefixes="#all">

  <xsl:output encoding="UTF-8"/>

  <xsl:param name="match-string" required="yes"/>
  <xsl:param name="match-field" select="'name'" required="yes"/>
  <xsl:param name="function-type" select="'download'" required="yes"/>
  <xsl:param name="override-existing" select="'no'" required="yes"/>

  <xsl:variable name="match-string-normalized">
    <xsl:call-template name="normalize-string">
      <xsl:with-param name="string" select="$match-string"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:template match="gmd:transferOptions/*/gmd:onLine/gmd:CI_OnlineResource">
    <xsl:if test="$match-string-normalized = ''">
      <xsl:message terminate="yes">Error: Empty parameter "match-string"</xsl:message>
    </xsl:if>

    <xsl:variable name="function">
      <xsl:choose>
        <xsl:when test="not(gmd:function) or $override-existing = 'yes'">
          <xsl:variable name="input-normalized">
            <xsl:call-template name="normalize-string">
              <xsl:with-param name="string">
                <xsl:choose>
                  <xsl:when test="$match-field = 'name'">
                    <xsl:value-of select="gmd:name/gco:CharacterString" disable-output-escaping="yes"/>
                  </xsl:when>
                  <xsl:when test="$match-field = 'url'">
                    <xsl:value-of select="gmd:linkage/gmd:URL" disable-output-escaping="yes"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:message terminate="yes">Error: Unsupported field "<xsl:value-of select="$match-field"/>"</xsl:message>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="contains($input-normalized, $match-string-normalized)">
              <gmd:function>
                <gmd:CI_OnLineFunctionCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#CI_OnLineFunctionCode">
                  <xsl:attribute name="codeListValue">
                    <xsl:value-of select="$function-type"/>
                  </xsl:attribute>
                </gmd:CI_OnLineFunctionCode>
              </gmd:function>
            </xsl:when>
            <xsl:otherwise>
              <xsl:copy-of select="gmd:function"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="gmd:function"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:copy>
      <xsl:copy-of select="*[not(name()='gmd:function')]"/>
      <xsl:copy-of select="$function"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>


  <!--
      Helpers
  -->

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
