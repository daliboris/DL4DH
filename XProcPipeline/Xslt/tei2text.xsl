<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xd"
    version="1.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Apr 16, 2020</xd:p>
            <xd:p><xd:b>Author:</xd:b> Boris</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:strip-space elements="*"/>
    <xsl:variable name="o" select="'&#xd;&#xa;'"/>
    
    <xsl:output method="text"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="//tei:text" />
       <xsl:if test="not(//tei:text//tei:w)">
        <!-- pokud je strana prázdná, vygenerovat alespoň odstavec -->
        <xsl:value-of select="$o"/> 
       </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:ab">
        <xsl:apply-templates select="tei:w | tei:reg[tei:w]" />
        <xsl:if test="position() != last()">
            <xsl:value-of select="concat($o, $o)"/>    
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:w">
        <xsl:apply-templates /><xsl:text> </xsl:text>
    </xsl:template>
    
</xsl:stylesheet>