<?xml version="1.0" encoding="UTF-8"?>
<!--
Supprime les namespaces XML inutilisés.

https://stackoverflow.com/a/4594626
-->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>
  
  <xsl:template match="*">
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:variable name="elem" select="."/>
      
      <xsl:for-each select="namespace::*">
        <xsl:variable name="prefix" select="name()"/>
        <xsl:if test="$elem/descendant::*[
                        (namespace-uri() = current() and substring-before(name(),':') = $prefix)
                        or @*[substring-before(name(),':') = $prefix]
                      ]">
          <xsl:copy-of select="."/>
        </xsl:if>
      </xsl:for-each>

      <xsl:apply-templates select="node()|@*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="node()|@*" priority="-2">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
