<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
 exclude-result-prefixes="xs xd"
 version="2.0">

 <xd:doc scope="stylesheet">
  <xd:desc>
   <xd:p><xd:b>Created on:</xd:b> Jul 8, 2021</xd:p>
   <xd:p><xd:b>Author:</xd:b> Boris</xd:p>
   <xd:p></xd:p>
  </xd:desc>
 </xd:doc>
 
 <xsl:output method="xml" omit-xml-declaration="no" indent="yes" />
 
 <xsl:template match="node() | @*">
  <xsl:copy>
   <xsl:apply-templates select="node() | @*"/>
  </xsl:copy>
 </xsl:template>
 
 
 <xsl:template match="udpipe">
  <xsl:copy>
   <xsl:copy-of select="@*" />
   <xsl:for-each-group select="*" group-starting-with="div">
    <div>
     <xsl:for-each-group select="current-group() except ." group-starting-with="p">
      <p>
       <xsl:for-each-group select="current-group() except ." group-starting-with="s">
        <s>
         <xsl:copy-of select="./@*" />
         <xsl:apply-templates select="current-group() except ." />
        </s>
       </xsl:for-each-group>
      </p>
     </xsl:for-each-group>
    </div>
   </xsl:for-each-group>
  </xsl:copy>
 </xsl:template>
 
</xsl:stylesheet>