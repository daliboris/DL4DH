<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:fn="http://www.w3.org/2005/xpath-functions" 
 exclude-result-prefixes="xs fn"
 version="3.0">
 
 <xsl:variable name="rn" select="'&#xd;&#xa;'"/>
 <xsl:output method="text" />
 
 <xsl:variable name="ns" select="concat('xmlns:dl4dh=', '&#x22;', 'https://system-kramerius.cz/ns/xproc/dl4dh/1.0', '&#x22;')"/>
 
 <xsl:template match="/">
<!--  <nametag>-->
   <xsl:apply-templates select="/fn:map/fn:string[@key='result']" />
  <!--</nametag>-->  
 </xsl:template>
 
 <xsl:template  match="fn:string[@key='result']">
  <xsl:variable name="text">
   <xsl:value-of select="replace(fn:replace(string(.), '\\&quot;', '&quot;'), '\\\\r\\\\n', '')"/> 
  </xsl:variable>
  <xsl:value-of select="concat('&lt;result source=', '&#x22;', ' ', $ns, 'nametag', '&#x22;','&gt;', $text, '&lt;/result&gt;')"/>
 </xsl:template>
 
</xsl:stylesheet>