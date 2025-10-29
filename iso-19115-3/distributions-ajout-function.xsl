<?xml version="1.0" encoding="UTF-8"?>
<!--
  Doc: https://github.com/ecolabdata/ecospheres-xslt/blob/main/xslts/iso-19139/distributions-add-function.md
-->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
                exclude-result-prefixes="#all">

  <xsl:include href="../helpers.xsl"/>

  <xsl:output encoding="UTF-8"/>

  <xsl:param name="match-field" required="yes"/>
  <xsl:param name="match-string" required="yes"/>
  <xsl:param name="function-type" select="'download'" required="yes"/>
  <xsl:param name="override-existing" select="'no'" required="yes"/>

  <xsl:variable name="match-string-normalized">
    <xsl:call-template name="normalize-string">
      <xsl:with-param name="string" select="$match-string"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:template match="mrd:transferOptions/*/mrd:onLine/cit:CI_OnlineResource">
    <xsl:if test="$match-field = ''">
      <xsl:message terminate="yes">Error: Empty parameter "match-field"</xsl:message>
    </xsl:if>
    <xsl:if test="$match-string-normalized = ''">
      <xsl:message terminate="yes">Error: Empty parameter "match-string"</xsl:message>
    </xsl:if>

    <xsl:variable name="function">
      <xsl:choose>
        <xsl:when test="not(cit:function) or $override-existing = 'yes'">
          <xsl:variable name="input-normalized">
            <xsl:call-template name="normalize-string">
              <xsl:with-param name="string">
                <xsl:choose>
                  <xsl:when test="$match-field = 'name'">
                    <xsl:value-of select="cit:name/gco:CharacterString" disable-output-escaping="yes"/>
                  </xsl:when>
                  <xsl:when test="$match-field = 'protocol'">
                    <!-- either Anchor or CharacterString -->
                    <xsl:value-of select="cit:protocol/*" disable-output-escaping="yes"/>
                  </xsl:when>
                  <xsl:when test="$match-field = 'url'">
                    <xsl:value-of select="cit:linkage/gco:CharacterString" disable-output-escaping="yes"/>
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
              <cit:function>
                <cit:CI_OnLineFunctionCode codeList="http://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#CI_OnLineFunctionCode">
                  <xsl:attribute name="codeListValue">
                    <xsl:value-of select="$function-type"/>
                  </xsl:attribute>
                </cit:CI_OnLineFunctionCode>
              </cit:function>
            </xsl:when>
            <xsl:otherwise>
              <xsl:copy-of select="cit:function"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="cit:function"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:copy>
      <xsl:copy-of select="*[not(name()='cit:function')]"/>
      <xsl:copy-of select="$function"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
