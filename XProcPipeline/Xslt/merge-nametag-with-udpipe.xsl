<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:math="http://www.w3.org/2005/xpath-functions/math"
 xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
 xmlns="http://www.tei-c.org/ns/1.0"
 xmlns:tei="http://www.tei-c.org/ns/1.0"
 exclude-result-prefixes="xs math xd"
 version="3.0">
 <xd:doc scope="stylesheet">
  <xd:desc>
   <xd:p><xd:b>Created on:</xd:b> Jul 10, 2021</xd:p>
   <xd:p><xd:b>Author:</xd:b> Boris</xd:p>
   <xd:p></xd:p>
  </xd:desc>
 </xd:doc>
 
 <xsl:param name="udpipe" as="element(tei:TEI)" />
 <xsl:variable name="udpipe-items" select="$udpipe/tei:text/tei:body/tei:div//(tei:w | tei:pc)"/>
 <xsl:variable name="nametag-items" select="/tei:TEI/tei:text/tei:body/tei:div//(tei:w | tei:pc)"/>

 <xsl:output method="xml" indent="yes" />


 <xsl:template match="node() | @*">
  <xsl:copy>
   <xsl:apply-templates select="node() | @*"/>
  </xsl:copy>
 </xsl:template>
 
 <xsl:template match="tei:publicationStmt">
  <xsl:copy>
   <xsl:copy-of select="@*" />
   <xsl:apply-templates />
   <xsl:copy-of select="$udpipe/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:availability" />
  </xsl:copy>
 </xsl:template>
 
 <xsl:template match="tei:encodingDesc">
  <xsl:copy>
   <xsl:copy-of select="@*" />
   <xsl:apply-templates />
   <xsl:copy-of select="$udpipe/tei:teiHeader/tei:encodingDesc/tei:appInfo" />
  </xsl:copy>
 </xsl:template>
 
 <xsl:template match="tei:textClass">
  <xsl:copy>
   <xsl:copy-of select="@*" />
   <xsl:apply-templates />
   <xsl:copy-of select="$udpipe/tei:teiHeader/tei:profileDesc/tei:textClass/tei:classCode" />
  </xsl:copy>  
 </xsl:template>
 
 <xsl:template match="tei:w | tei:pc">
  <xsl:variable name="i" select="count(preceding::tei:w | preceding::tei:pc) + 1"/>
  <xsl:variable name="up-e" select="$udpipe-items[$i]"/>
  <xsl:copy>
   <xsl:copy-of select="@*" />
   <xsl:if test=". = $up-e/.">
    <xsl:copy-of select="$up-e/@*" />
   </xsl:if>
   <xsl:apply-templates />
  </xsl:copy>
 </xsl:template>

 <!--
 <xsl:template match="tei:text/tei:body/tei:div">
 
  <xsl:copy>
   <xsl:copy-of select="@*" />

   <xsl:for-each select=".//(tei:w | tei:pc)">
    <xsl:variable name="i" select="position()"/>
    <xsl:variable name="e" select="."/>
    <xsl:variable name="up-e" select="$items[$i]"/>
    <xsl:if test="$e/. = $up-e/.">
     <xsl:element name="{name($e)}">
      <xsl:copy-of select="$e/@*"/>
      <xsl:copy-of select="$up-e/@*" />
      <xsl:apply-templates select="$e" />
     </xsl:element>
    </xsl:if>
   </xsl:for-each>
   
  </xsl:copy>
 </xsl:template>-->
 
</xsl:stylesheet>