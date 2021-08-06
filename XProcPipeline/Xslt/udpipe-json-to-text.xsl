<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:fn="http://www.w3.org/2005/xpath-functions" 
 xmlns:dl4dh="https://system-kramerius.cz/ns/xproc/dl4dh/1.0" 
 exclude-result-prefixes="xs fn"
 version="3.0">
 
 <xsl:variable name="rn" select="'&#xd;&#xa;'"/> <!-- &#xa; -->
 <xsl:variable name="tab" select="'&#x9;'"/>
 <xsl:output method="text" />
 
 <xsl:template match="/">
   <!--<xsl:apply-templates select="/fn:map/fn:string[@key='result']" />-->
   <xsl:apply-templates select="dl4dh:result" />
 </xsl:template>
 
 <xsl:template  match="fn:string[@key='result'] | dl4dh:result">
  <xsl:variable name="text" as="xs:string">
    <xsl:value-of select="."/>
   <!--<xsl:value-of select="replace(string(.), '\\t', $tab)"/> -->
    <!--<xsl:value-of select="replace(string(.), '\\', 'QQQ')"/>-->
  </xsl:variable>
  <!--<xsl:value-of select="$text => replace('\\t', $tab) => replace('\\n', $rn)"/>-->
  <xsl:value-of select="$text 
   => replace('\\t', $tab)
   => replace('\\n\\n', $rn)
   => replace('\\n', $rn) 
   => replace('SpacesAfter=\\\\s\\\\r\\', 'SpacesAfter=No')
   => replace('\\\\r', '')
   => replace('=\\', '=')
   "/>
 </xsl:template>
 <!-- => replace(., '\\n', $rn)  -->
 
</xsl:stylesheet>