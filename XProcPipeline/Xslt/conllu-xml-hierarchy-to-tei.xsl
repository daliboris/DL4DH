<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="http://www.tei-c.org/ns/1.0" xmlns:dl4dh="https://system-kramerius.cz/ns/xproc/dl4dh/1.0" exclude-result-prefixes="xs xd tei dl4dh" version="2.0">

 <xd:doc scope="stylesheet">
  <xd:desc>
   <xd:p><xd:b>Created on:</xd:b> Jul 8, 2021</xd:p>
   <xd:p><xd:b>Author:</xd:b> Boris</xd:p>
   <xd:p />
  </xd:desc>
 </xd:doc>

 <xsl:output method="xml" omit-xml-declaration="no" indent="yes" />

 <xsl:template match="node() | @*">
  <xsl:copy>
   <xsl:apply-templates select="node() | @*" />
  </xsl:copy>
 </xsl:template>

 <xsl:template match="*" priority="2">
  <xsl:element name="{name()}">
   <xsl:apply-templates select="node() | @*" />
  </xsl:element>
 </xsl:template>


 <xsl:template match="udpipe" priority="5">
  
  <xsl:variable name="id" select="substring-before(@generator, ' ')" />
  
  <TEI xmlns="http://www.tei-c.org/ns/1.0">
   <teiHeader>
    <fileDesc>
     <titleStmt>
      <title />
     </titleStmt>
     <editionStmt>
      <p />
     </editionStmt>
     <publicationStmt>
      <publisher />
       <availability>
        <licence resp="#{$id}"><xsl:value-of select="@licence"/></licence>
       </availability>
     </publicationStmt>
     <sourceDesc>
      <bibl />
     </sourceDesc>
    </fileDesc>
    <encodingDesc>
   <appInfo>
    <application xml:id="{$id}" ident="{$id}" version="{substring-before(substring-after(@generator, ' '), ',')}">
     <label>
      <xsl:value-of select="substring-before(@generator, ' ')"/>
      <xsl:text>, model: </xsl:text>
      <xsl:value-of select="@model"/>
     </label>
    </application>
   </appInfo>
  </encodingDesc>
   </teiHeader>
   <text>
    <body>
     <xsl:apply-templates />
    </body>
   </text>
  </TEI>
 </xsl:template>

 <xsl:template match="w[@pos = 'PUNCT']" priority="5">
  <pc>
   <xsl:copy-of select="@*" />
   <xsl:apply-templates />
  </pc>
 </xsl:template>
 
 <!--
  chyby typu:
  <w n="\&#xD;"/>
  <w n=""/>
 -->
 <xsl:template match="w[not(@pos)]" priority="10" />
 
 <!--
  případy typu:
     <w n="8-9" lemma="_" pos="_" msd="_">aby</w>
    <w n="8" lemma="aby" pos="SCONJ" msd="J,">aby</w>
    <w n="9" lemma="být" pos="AUX" msd="Vc">by</w>
-->
 <xsl:template match="w[contains(@n, '-')]" priority="10">
  <xsl:variable name="numbers" select="tokenize(@n, '-')" />
  <xsl:variable name="words" select="following-sibling::w[@n = $numbers]"/>

  <xsl:element name="w">
   <xsl:for-each select="@*">
    <xsl:variable name="att-name" select="name()"/>
    <xsl:attribute name="{$att-name}">
     <xsl:value-of select="$words/@*[name() = $att-name]" separator="|"/>
    </xsl:attribute>
   </xsl:for-each>
   <xsl:apply-templates />
  </xsl:element>

 </xsl:template>
 
 <xsl:template match="w" priority="4">
  <xsl:variable name="n" select="@n"/>
  <xsl:choose>
   <xsl:when test="preceding-sibling::w[contains(@n, $n)]">
    <!--<xsl:comment> skipping </xsl:comment>-->
   </xsl:when>
   <xsl:otherwise>
    <xsl:element name="{name()}">
     <xsl:apply-templates select="node() | @*" />
    </xsl:element>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>
 
 

</xsl:stylesheet>
