<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                extension-element-prefixes="exsl"
                exclude-result-prefixes="#all">


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
            <xsl:variable name="label-url" select="substring-after($normalized, '://')"/>
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

</xsl:stylesheet>
