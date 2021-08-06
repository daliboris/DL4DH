<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:foxml="info:fedora/fedora-system:def/foxml#"
 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
 xmlns:or="http://www.nsdl.org/ontologies/relationships#"
 xmlns:dl4dh="https://system-kramerius.cz/ns/xproc/dl4dh/1.0"
 exclude-result-prefixes="xs foxml rdf or"
 version="2.0"
 >
 
 <xsl:output method="xml" indent="yes" />
 
 <xsl:template match="/">
  <dl4dh:uuids>
   <!--<xsl:apply-templates select="/foxml:digitalObject/foxml:datastream[@ID='RELS-EXT']/foxml:datastreamVersion[@ID='RELS-EXT.11']/foxml:xmlContent//rdf:Description/or:hasPage" />-->
   
   <xsl:apply-templates select="/foxml:digitalObject//rdf:Description[or:hasPage][1]/or:hasPage" />
  </dl4dh:uuids>
 </xsl:template>
 
 <!--
  /foxml:digitalObject/foxml:datastream[5]/foxml:datastreamVersion[1]/foxml:xmlContent[1]/*[namespace-uri()='http://www.w3.org/1999/02/22-rdf-syntax-ns#' and local-name()='RDF'][1]/*[namespace-uri()='http://www.w3.org/1999/02/22-rdf-syntax-ns#' and local-name()='Description'][1]
 -->
 
 <xsl:template match="or:hasPage">
  <dl4dh:uuid>
   <xsl:value-of select="substring-after(@rdf:resource, 'info:fedora/uuid:')"/>   
  </dl4dh:uuid>
 </xsl:template>
 
</xsl:stylesheet>