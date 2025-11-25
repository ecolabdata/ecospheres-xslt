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

  <!-- In safe-mode, only the sub-trees matching this template will be recursively pruned.
       The rest of the tree will be preserved as-is, without any pruning.

       Paths should be AS SPECIFIC AS POSSIBLE to avoid matching in unexpected locations:
       - Ancestors restrict where in the tree we can safely match.
       - Pruning starts at the last element in the path, that last element included.

       Examples:

       match="gmd:identifier"
       => Prune gmd:identifier sub-tree (when empty) anywhere in the tree.

       match="gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier"
       => Prune gmd:identifier sub-tree (when empty) only under //gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation.

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
  <xsl:template match="gco:CharacterString" name="preserve-with-parent"
                mode="prune-maybe" priority="1">
    <xsl:copy-of select="."/>
  </xsl:template>

  <!-- Recursive pruning template -->
  <xsl:template match="*" mode="prune-all prune-maybe">
    <!-- say we recursively pruned the sub-tree from our current node -->
    <xsl:variable name="kids">
      <xsl:apply-templates select="node()" mode="#current"/>
    </xsl:variable>

    <!-- ... let's see what the result tree (current node + subtree) looks like -->
    <xsl:choose>
      <xsl:when test="not(@*) and not(normalize-space($kids)) and not($kids/*)">
        <!-- the resulting tree is empty => we're done, there's nothing to output -->
      </xsl:when>
      <xsl:otherwise>
        <!-- the resulting tree is not empty => recurse more carefully -->
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates select="node()" mode="prune-maybe"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- Identity template when not pruning -->
  <xsl:template match="@*|node()" mode="prune-off">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="prune-off"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
