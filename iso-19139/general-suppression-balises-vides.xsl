<?xml version="1.0" encoding="UTF-8"?>
<!--
  Doc: https://github.com/ecolabdata/ecospheres-xslt/blob/main/iso-19139/general-suppression-balises-vides.md
-->

<xsl:stylesheet
    version="2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gco="http://www.isotc211.org/2005/gco"
    xmlns:gml="http://www.opengis.net/gml"
    exclude-result-prefixes="#all">

  <xsl:param name="safe-mode" select="'yes'"/>
  <!-- TODO: <xsl:param name="safe-mode" select="true()" as="xs:boolean"/> -->

  <!-- Entry point -->
  <xsl:template match="/" priority="1">
    <xsl:choose>
      <xsl:when test="$safe-mode != 'no'">
        <!-- don't prune until we match specific xpaths -->
        <xsl:apply-templates mode="prune-off"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- start pruning right away -->
        <xsl:apply-templates mode="prune-all"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- In safe-mode, only sub-trees matching this template will be pruned.
       The rest of the tree will be preserved as-is.

       Paths should be AS SPECIFIC AS POSSIBLE to avoid matching in unexpected locations:
       - Ancestors restrict where in the tree we can safely prune.
       - Pruning starts at the last element in the path, with that last element included.

       Examples:

       match="gmd:identifier"
       => Prune gmd:identifier sub-tree anywhere in the tree.

       match="gmd:identifier/*"
       => Prune sub-trees under gmd:identifier, but preserving the gmd:identifier nodes.

       match="gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier"
       => Prune gmd:identifier sub-tree only under //gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation.

       Expected format: match="some/path | another/different/path | ..."
  -->
  <xsl:template match="gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier"
                mode="prune-off" priority="1">
    <!-- start pruning sub-tree -->
    <xsl:apply-templates select="." mode="prune-all"/>
  </xsl:template>

  <!-- Some elements should only be removed when the parent would itself be recursively removed,
       i.e. the parent has no attributes or other non-empty children.

       For instance, the GeoNetwork editor seems to rely on `gco:CharacterString` to display
       its text boxes, so we should only remove them when we also remove the parent.

       Expected format: match="ns1:element | ns2:other_element | ..."
  -->
  <xsl:template match="gco:CharacterString"
                mode="prune-maybe" priority="1">
    <xsl:copy-of select="."/>
  </xsl:template>

  <!-- Recursive pruning template -->
  <xsl:template match="*" mode="prune-all prune-maybe">
    <!-- say we pruned the sub-tree while ignoring the "prune-maybe" rules... -->
    <xsl:variable name="kids">
      <xsl:apply-templates select="node()" mode="prune-all"/>
    </xsl:variable>

    <!-- ...what would the resulting tree (current node + pruned sub-tree) look like? -->
    <xsl:choose>
      <xsl:when test="not(@*) and not(normalize-space($kids)) and not($kids/*)">
        <!-- tree would be empty => we're done -->
      </xsl:when>
      <xsl:otherwise>
        <!-- tree would not be empty => keep current node and recurse with "prune-maybe" rules -->
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates select="node()" mode="prune-maybe"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- Identity template when pruning is disabled -->
  <xsl:template match="@*|node()" mode="prune-off">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="prune-off"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
