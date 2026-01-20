<?xml version="1.0" encoding="UTF-8"?>
<!--
  Doc: https://github.com/ecolabdata/ecospheres-xslt/blob/main/iso-19139/maintenance-relocate-element.md
-->

<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                exclude-result-prefixes="#all">

  <xsl:output encoding="UTF-8"/>

  <xsl:variable name="source"
                select="/gmd:MD_Metadata/gmd:metadataMaintenance/gmd:MD_MaintenanceInformation"/>
  <xsl:variable name="destination"
                select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceMaintenance/gmd:MD_MaintenanceInformation"/>

  <!-- Source-side processing -->
  <xsl:template match="/gmd:MD_Metadata/gmd:metadataMaintenance">
    <xsl:choose>
      <xsl:when test="$destination">
        <xsl:message>[isomorphe:check] 'gmd:metadataMaintenance' écraserait 'gmd:resourceMaintenance'.</xsl:message>
        <xsl:copy-of select="."/>
      </xsl:when>
      <xsl:otherwise>
        <!-- will move to gmd:MD_DataIdentification/gmd:resourceMaintenance -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Destination-side processing -->
  <xsl:template match="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification[$source][not($destination)]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="*[not(self::gmd:resourceMaintenance)]"/>
      <xsl:choose>
        <xsl:when test="gmd:resourceMaintenance">
          <xsl:copy select="gmd:resourceMaintenance">
            <xsl:apply-templates select="$source"/>
          </xsl:copy>
        </xsl:when>
        <xsl:otherwise>
          <gmd:resourceMaintenance>
            <xsl:apply-templates select="$source"/>
          </gmd:resourceMaintenance>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
