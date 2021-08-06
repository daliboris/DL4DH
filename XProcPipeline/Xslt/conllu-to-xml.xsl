<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:math="http://www.w3.org/2005/xpath-functions/math"
 xmlns:map="http://www.w3.org/2005/xpath-functions/map"
 xmlns:array="http://www.w3.org/2005/xpath-functions/array" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs math xd map array" version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jul 6, 2021</xd:p>
            <xd:p><xd:b>Author:</xd:b> Boris</xd:p>
            <xd:p>Konverze formátu <xd:a href="http://universaldependencies.org/docs/format.html">CoNLL-U v2</xd:a> (viz též <xd:a href="https://ufal.mff.cuni.cz/udpipe/1/users-manual#run_udpipe_output">dokumentace UDPipe</xd:a>) do XML.</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:output method="xml" indent="true" />

    <xsl:param name="input" as="xs:string" />

    <xsl:variable name="attributes" as="map(xs:integer, xs:string)">
        <xsl:map>
            <xsl:map-entry key="1" select="'n'" />
            <xsl:map-entry key="3" select="'lemma'" />
            <xsl:map-entry key="4" select="'pos'" />
<!--            <xsl:map-entry key="5" select="'msd'" />-->
            <xsl:map-entry key="6" select="'msd'" />
        </xsl:map>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:variable name="input" select="tokenize($input, '\n')" />

        <udpipe>
            <xsl:call-template name="get-attributes">
                <xsl:with-param name="input" select="$input" />
            </xsl:call-template>

            <xsl:for-each select="$input">
                <xsl:choose>
                    <xsl:when test="starts-with(., '# newdoc')">
                        <div />
                    </xsl:when>
                    <xsl:when test="starts-with(., '# newpar')">
                        <p />
                    </xsl:when>
                    <xsl:when test="starts-with(., '# sent_id')">
                        <s n="{normalize-space(substring-after(., '='))}" />
                    </xsl:when>
                    <xsl:when test="starts-with(., '#')">
                        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="items" select="tokenize(., '\t')" />
                        <xsl:if test="$items[1] != ''">
                            <w>
                                <xsl:for-each select="$items">
                                    <xsl:variable name="item" select="." />
                                    <xsl:variable name="position" select="position()" />

                                    <xsl:if test="map:contains($attributes, $position)">
                                        <xsl:attribute name="{map:get($attributes, $position)}" select="$item" />
                                    </xsl:if>
                                </xsl:for-each>
                                <xsl:value-of select="$items[2]" />
                            </w>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>

            </xsl:for-each>
        </udpipe>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>Ze vstupního dokumentu získá metadata o zpracování.</xd:p>
        </xd:desc>
        <xd:param name="input" />
    </xd:doc>
    <xsl:template name="get-attributes">
        <xsl:param name="input" />

        <xsl:for-each select="$input">
            <xsl:choose>
                <xsl:when test="starts-with(., '# generator ')">
                    <xsl:attribute name="generator" select="normalize-space(substring-after(., '='))" />
                </xsl:when>
                <xsl:when test="starts-with(., '# udpipe_model ')">
                    <xsl:attribute name="model" select="normalize-space(substring-after(., '='))" />
                </xsl:when>
                <xsl:when test="starts-with(., '# udpipe_model_licence ')">
                    <xsl:attribute name="licence" select="normalize-space(substring-after(., '='))" />
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>

    </xsl:template>

</xsl:stylesheet>
