<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:map="http://www.w3.org/2005/xpath-functions/map"
 xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="http://www.tei-c.org/ns/1.0" xmlns:dl4dh="https://system-kramerius.cz/ns/xproc/dl4dh/1.0" exclude-result-prefixes="xs math map xd tei dl4dh" version="3.0">
 <xsl:import href="nametag-tei-profile-description.xsl"/>

 <xd:doc scope="stylesheet">
  <xd:desc>
   <xd:p><xd:b>Created on:</xd:b> Jul 8, 2021</xd:p>
   <xd:p><xd:b>Author:</xd:b> Boris</xd:p>
   <xd:p/>
  </xd:desc>
 </xd:doc>


 <xsl:output method="xml" indent="yes"/>

 <xsl:variable name="attributes" as="map(xs:string, xs:string)">
  <xsl:map>
   <xsl:map-entry key="'C'" select="'bibliography'"/>
   <xsl:map-entry key="'at'" select="'phone'"/>
   <xsl:map-entry key="'az'" select="'zip'"/>
   <xsl:map-entry key="'gh'" select="'water'"/>
   <xsl:map-entry key="'gl'" select="'area'"/>
   <xsl:map-entry key="'gt'" select="'continent'"/>
   <xsl:map-entry key="'no'" select="'ordinal'"/>
   <xsl:map-entry key="'oa'" select="'artefact'"/>
   <xsl:map-entry key="'op'" select="'product'"/>
   <xsl:map-entry key="'or'" select="'rule'"/>
   <xsl:map-entry key="'pc'" select="'population'"/>
   <xsl:map-entry key="'pm'" select="'middle'"/>
   <xsl:map-entry key="'tf'" select="'holiday'"/>
  </xsl:map>
 </xsl:variable>

 <xsl:variable name="months" as="map(xs:string, xs:integer)">
  <xsl:map>
   <xsl:map-entry key="'leden'" select="1"/>
   <xsl:map-entry key="'únor'" select="2"/>
   <xsl:map-entry key="'březen'" select="3"/>
   <xsl:map-entry key="'duben'" select="4"/>
   <xsl:map-entry key="'květen'" select="5"/>
   <xsl:map-entry key="'červen'" select="6"/>
   <xsl:map-entry key="'červenec'" select="7"/>
   <xsl:map-entry key="'srpen'" select="8"/>
   <xsl:map-entry key="'září'" select="9"/>
   <xsl:map-entry key="'říjen'" select="10"/>
   <xsl:map-entry key="'listopad'" select="11"/>
   <xsl:map-entry key="'prosinec'" select="12"/>
   
   <xsl:map-entry key="'ledna'" select="1" />
   <xsl:map-entry key="'února'" select="2" />
   <xsl:map-entry key="'března'" select="3" />
   <xsl:map-entry key="'dubna'" select="4" />
   <xsl:map-entry key="'května'" select="5" />
   <xsl:map-entry key="'června'" select="6" />
   <xsl:map-entry key="'července'" select="7" />
   <xsl:map-entry key="'srpna'" select="8" />
<!--   <xsl:map-entry key="'září'" select="9" />-->
   <xsl:map-entry key="'října'" select="10" />
   <xsl:map-entry key="'listopadu'" select="11" />
   <xsl:map-entry key="'prosince'" select="12" />
  </xsl:map>
 </xsl:variable>


 <xsl:template match="dl4dh:result[@source = 'NameTag']">
  <xsl:variable name="id" select="@source"/>

  <TEI xmlns="http://www.tei-c.org/ns/1.0">
   <teiHeader>
    <fileDesc>
     <titleStmt>
      <title/>
     </titleStmt>
     <editionStmt>
      <p/>
     </editionStmt>
     <publicationStmt>
      <publisher/>
      <availability>
       <licence resp="#{$id}">CC BY-NC-SA</licence>
       <!-- licence uvedená na stránce  http://lindat.mff.cuni.cz/services/udpipe/; součástí odpovědi REST není-->
      </availability>
     </publicationStmt>
     <sourceDesc>
      <bibl/>
     </sourceDesc>
    </fileDesc>
    <encodingDesc>
     <appInfo>
      <application xml:id="{$id}" ident="{$id}" version="2">
       <label>
        <xsl:value-of select="$id"/>
        <xsl:text>, model: </xsl:text>
        <xsl:value-of select="@model"/>
       </label>
      </application>
     </appInfo>
    </encodingDesc>
    <profileDesc>
     <textClass>
      <xsl:call-template name="nametag-classCode"/>
     </textClass>
    </profileDesc>
   </teiHeader>
   <text>
    <body>
     <div>
      <p>
       <xsl:apply-templates/>
      </p>
     </div>
    </body>
   </text>
  </TEI>
 </xsl:template>

 <xsl:template match="sentence">
  <s>
   <xsl:apply-templates/>
  </s>
 </xsl:template>

 <xsl:template match="token">
  <xsl:choose>
   <xsl:when test="matches(., '\p{P}')">
    <pc>
     <xsl:apply-templates/>
    </pc>
   </xsl:when>
   <xsl:otherwise>
    <w>
     <xsl:apply-templates/>
    </w>
   </xsl:otherwise>
  </xsl:choose>

 </xsl:template>

 <!-- ČÍSLA JAKO SOUČÁSTI ADRES -->
 <xsl:template match="ne[@type = ('ah', 'at', 'az')]">
  <num>
   <xsl:call-template name="add-attribute-type"/>
   <xsl:call-template name="add-attribute-ana"/>
   <xsl:apply-templates/>
  </num>
 </xsl:template>

 <!-- Komplexní bibliografický záznam -->
 <xsl:template match="ne[@type = 'C']">
  <objectName>
   <xsl:call-template name="add-attribute-type"/>
   <xsl:call-template name="add-attribute-ana"/>
   <xsl:apply-templates/>
  </objectName>
 </xsl:template>

 <!-- GEOGRAFICKÉ NÁZVY -->
 <xsl:template match="ne[@type = 'gc']">
  <placeName>
   <xsl:call-template name="add-attribute-ana"/>
   <country>
    <xsl:apply-templates/>
   </country>
  </placeName>
 </xsl:template>

 <xsl:template match="ne[@type = ('gh', 'gl', 'gt')]">
  <geogName>
   <xsl:call-template name="add-attribute-ana"/>
   <xsl:call-template name="add-attribute-type"/>
   <xsl:apply-templates/>
  </geogName>
 </xsl:template>

 <xsl:template match="ne[@type = ('gq', 'gu')]">
  <placeName>
   <xsl:call-template name="add-attribute-ana"/>
   <settlement>
    <xsl:apply-templates/>
   </settlement>
  </placeName>
 </xsl:template>

 <xsl:template match="ne[@type = 'gr']">
  <placeName>
   <xsl:call-template name="add-attribute-ana"/>
   <region>
    <xsl:apply-templates/>
   </region>
  </placeName>
 </xsl:template>

 <xsl:template match="ne[@type = 'gs']">
  <address>
   <xsl:call-template name="add-attribute-ana"/>
   <street>
    <xsl:apply-templates/>
   </street>
  </address>
 </xsl:template>

 <xsl:template match="ne[@type = 'g_']">
  <placeName>
   <xsl:call-template name="add-attribute-ana"/>
   <xsl:apply-templates/>
  </placeName>
 </xsl:template>


 <!-- NÁZVY INSTITUCÍ -->

 <xsl:template match="ne[@type = 'ia']">
  <objectName>
   <xsl:call-template name="add-attribute-ana"/>
   <xsl:apply-templates/>
  </objectName>
 </xsl:template>

 <xsl:template match="ne[@type = ('ic', 'if', 'io', 'i_')]">
  <orgName>
   <xsl:call-template name="add-attribute-ana"/>
   <xsl:apply-templates/>
  </orgName>
 </xsl:template>

 <!-- NÁZVY MÉDIÍ -->

 <xsl:template match="ne[@type = 'me']">
  <email>
   <xsl:apply-templates/>
  </email>
 </xsl:template>

 <xsl:template match="ne[@type = 'mi']">
  <ref target=".">
   <xsl:call-template name="add-attribute-ana"/>
   <xsl:apply-templates/>
  </ref>
 </xsl:template>

 <xsl:template match="ne[@type = ('mn', 'ms')]">
  <orgName>
   <xsl:call-template name="add-attribute-ana"/>
   <xsl:apply-templates/>
  </orgName>
 </xsl:template>

 <!-- ČÍSLA SE SPECIFICKÝM VÝZNAMEM -->

 <xsl:template match="ne[@type = ('na', 'nc', 'nb', 'no', 'ns', 'ni', 'n_')]">
  <num>
   <xsl:call-template name="add-attribute-type"/>
   <xsl:call-template name="add-attribute-ana"/>
   <xsl:apply-templates/>
  </num>
 </xsl:template>

 <!-- NÁZVY VĚCÍ -->

 <xsl:template match="ne[@type = ('oa', 'op', 'or', 'o_')]">
  <objectName>
   <xsl:call-template name="add-attribute-type"/>
   <xsl:call-template name="add-attribute-ana"/>
   <xsl:apply-templates/>
  </objectName>
 </xsl:template>

 <xsl:template match="ne[@type = ('oe', 'om')]">
  <unit>
   <xsl:call-template name="add-attribute-type"/>
   <xsl:call-template name="add-attribute-ana"/>
   <xsl:apply-templates/>
  </unit>
 </xsl:template>

 <!-- JMÉNA OSOB -->

 <xsl:template match="ne[@type = ('pc', 'p_')]">
  <name>
   <xsl:call-template name="add-attribute-type"/>
   <xsl:call-template name="add-attribute-ana"/>
   <xsl:apply-templates/>
  </name>
 </xsl:template>

 <xsl:template match="ne[@type = 'pd']">
  <abbr>
   <xsl:call-template name="add-attribute-type"/>
   <xsl:call-template name="add-attribute-ana"/>
   <xsl:apply-templates/>
  </abbr>
 </xsl:template>

 <xsl:template match="ne[@type = 'P']">
  <persName>
   <xsl:call-template name="add-attribute-ana"/>
   <xsl:apply-templates/>
  </persName>
 </xsl:template>

 <xsl:template match="ne[@type = ('pf', 'pm')]">
  <forename>
   <xsl:call-template name="add-attribute-type"/>
   <xsl:call-template name="add-attribute-ana"/>
   <xsl:apply-templates/>
  </forename>
 </xsl:template>

 <xsl:template match="ne[@type = ('pp')]">
  <persName>
   <xsl:call-template name="add-attribute-type"/>
   <xsl:call-template name="add-attribute-ana"/>
   <xsl:apply-templates/>
  </persName>
 </xsl:template>

 <xsl:template match="ne[@type = ('ps')]">
  <surname>
   <xsl:call-template name="add-attribute-type"/>
   <xsl:call-template name="add-attribute-ana"/>
   <xsl:apply-templates/>
  </surname>
 </xsl:template>

 <!-- ČASOVÉ ÚDAJE -->

 <xsl:template match="ne[@type = ('T', 'td', 'ty', 'tm')]">
  <date>
   <xsl:call-template name="add-attribute-type"/>
   <xsl:call-template name="add-attribute-ana"/>
   <xsl:call-template name="add-attribute-when"/>
   <xsl:apply-templates/>
  </date>
 </xsl:template>

 <!-- svátky -->
 <xsl:template match="ne[@type = ('tf')]">
  <date>
   <xsl:call-template name="add-attribute-type"/>
   <xsl:call-template name="add-attribute-ana"/>
   <xsl:apply-templates/>
  </date>
 </xsl:template>
 
 <!-- hodina -->
 <xsl:template match="ne[@type = ('th')]">
  <time>
   <xsl:call-template name="add-attribute-type"/>
   <xsl:call-template name="add-attribute-ana"/>
   <xsl:apply-templates/>
  </time>
 </xsl:template>

 <xsl:template name="add-attribute-when">
  <xsl:choose>
   <xsl:when test="@type = 'T'">
    <xsl:attribute name="when" select="dl4dh:get-when-value(.)"/>
   </xsl:when>
   <xsl:when test="@type = 'ty'">
    <xsl:attribute name="when" select="dl4dh:get-when-value(.)"/>
   </xsl:when>
   <xsl:when test="@type = 'tm'">
    <xsl:attribute name="when" select="concat('--', dl4dh:get-when-value(.))"/>
   </xsl:when>
   <xsl:when test="@type = 'td'">
    <xsl:attribute name="when" select="concat('---', dl4dh:get-when-value(.))"/>
   </xsl:when>
  </xsl:choose>
 </xsl:template>
 
 <xsl:function name="dl4dh:get-when-value" as="xs:string">
  <xsl:param name="ne" as="element(ne)?" />
  <xsl:choose>
   <xsl:when test="not($ne)">
    <xsl:text></xsl:text>
   </xsl:when>
   <xsl:when test="$ne[@type='T']">
    <xsl:value-of select="concat(
     if($ne/ne[@type='ty']) then '' else '-',
     dl4dh:get-when-value($ne/ne[@type='ty']),
     if($ne/ne[@type='tm']) then '-' else '',
     dl4dh:get-when-value($ne/ne[@type='tm']),
     if($ne/ne[@type='td']) then '-' else '',
     dl4dh:get-when-value($ne/ne[@type='td'])
     )"/>
   </xsl:when>
   <xsl:when test="$ne[@type='ty']">
    <xsl:value-of select="normalize-space($ne)"/>
   </xsl:when>
   <xsl:when test="$ne[@type='tm']">
    <xsl:value-of select="format-number(map:get($months, lower-case(normalize-space($ne))), '00')"/>
   </xsl:when>
   <xsl:when test="$ne[@type='td']">
    <xsl:value-of select="format-number($ne/token[string(number()) != 'NaN'][1], '00')"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text></xsl:text>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:function>

 <xsl:template name="add-attribute-ana">
  <xsl:if test="self::ne[@type]">
   <xsl:attribute name="ana" select="concat('#nametag-', @type)"/>
  </xsl:if>
 </xsl:template>

 <xsl:template name="add-attribute-type">
  <xsl:if test="map:contains($attributes, self::ne/@type)">
   <xsl:attribute name="type" select="map:get($attributes, self::ne/@type)"/>
  </xsl:if>
 </xsl:template>

</xsl:stylesheet>
