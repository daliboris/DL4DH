<p:library xmlns:p="http://www.w3.org/ns/xproc" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dl4dh="https://system-kramerius.cz/ns/xproc/dl4dh/1.0" xmlns="http://www.w3.org/1999/xhtml" version="3.0">

 <p:documentation>
  <section />
 </p:documentation>

 <p:declare-step type="dl4dh:tei-to-text">
  <p:input port="source" />
  <p:output port="result" sequence="true" />


  <p:xslt version="2.0">
   <p:with-input port="stylesheet" href="../Xslt/tei2text.xsl" />
  </p:xslt>

 </p:declare-step>

 <p:declare-step type="dl4dh:convert-tei-items-to-text" name="convert-tei-items-to-text">
  <p:documentation />

  <p:input port="source" />
  <p:output port="result" primary="true" serialization="map{'indent' : true()}" pipe="@final-report" />
  <p:output port="data" serialization="map{'indent' : true()}" sequence="true" />

  <p:variable name="main-directory-path" select="//dl4dh:request/@main-directory-path" />

  <p:variable name="service" select="//dl4dh:request/dl4dh:service[@name='Tei']" />

  <p:variable name="result-directory-path" select="concat($main-directory-path, $service/dl4dh:item[@name='tei-text-directory-path']/@value)">
   <p:documentation>Složka, do níž se uloží stažené dokumenty. Cesta ke složce může být absolutní i relativní.</p:documentation>
  </p:variable>
  <p:variable name="previous-step" select="/dl4dh:report/dl4dh:result/dl4dh:step[@service='Alto' and @name='convert-alto-items-to-tei']" />
  <p:variable name="previous-directory-path" select="$previous-step/@result-directory-path" />
  <p:variable name="items" select="$previous-step//dl4dh:item[@type='tei']" />

  <p:for-each name="loop">
   <p:with-input select="$items" />
   <p:output port="result" pipe="result@item-metadata" />
   <p:output port="data" primary="false" pipe="result@get-data" />

   <p:variable name="uuid" select="dl4dh:item/@uuid" />

   <p:variable name="file-name" select="concat($uuid, '.txt')" />
   <p:variable name="saved-file-path" select="p:urify(concat($result-directory-path, $file-name))" />

   <p:variable name="href" select="concat($previous-directory-path, dl4dh:item/@filename)" />

   <dl4dh:tei-to-text name="get-data" p:message="convert-tei-items-to-text|tei-to-text: {$href} ">
    <p:with-input port="source" href="{$href}" />
   </dl4dh:tei-to-text>
   
   <!-- pokud stránka neobsahuje žádný text, vygeneruje se alespoň mezera -->
<!--   <p:if test="()" message="empty">
    <p:identity>
     <p:with-input>
      <p:inline>XXXX</p:inline>
     </p:with-input>
    </p:identity>
   </p:if>-->

   <p:if test="$result-directory-path">
    <p:store href="{$saved-file-path}" />
   </p:if>

   <p:identity name="item-metadata">
    <p:with-input>
     <dl4dh:item uuid="{$uuid}" filename="{$file-name}" type="txt" />
    </p:with-input>
   </p:identity>

  </p:for-each>

  <p:identity name="data">
   <p:with-input port="source" pipe="data@loop" />
  </p:identity>

  <p:wrap-sequence wrapper="dl4dh:step">
   <p:with-input port="source" pipe="result@loop" />
   <p:documentation>Zabalení sekvence elementů <b>&lt;dl4dh:item&lt;</b> do nadřazeného elementu.</p:documentation>
  </p:wrap-sequence>
  <p:set-attributes match="/*" attributes="map{
   'service' : $service/@name, 
   'name' :  'convert-tei-items-to-text', 
   'result-directory-path' : $result-directory-path 
   }" />

  <p:identity name="metadata" />

  <p:insert match="dl4dh:report/dl4dh:result" position="last-child" name="final-report">
   <p:documentation>Doplnění zprávy o zpracovaných prvcích.</p:documentation>
   <p:with-input port="source" pipe="source@convert-tei-items-to-text" />
   <p:with-input port="insertion" pipe="@metadata" />
  </p:insert>

 </p:declare-step>

 <p:declare-step type="dl4dh:convert-nametag-to-tei">
  <p:input port="source" />
  <p:output port="result" />


  <p:xslt version="2.0" message="Transforming from NameTag to TEI">
   <p:with-input port="stylesheet" href="../Xslt/nametag-xml-to-tei.xsl" />
  </p:xslt>

 </p:declare-step>

 <p:declare-step type="dl4dh:convert-nametag-items-to-tei" name="convert-nametag-items-to-tei">
  <p:documentation>Dokumenty s anotací entit programem NameTag ve formátu XML převede do formátu TEI s odpovídajícími elementy. </p:documentation>

  <p:input port="source" />
  <p:output port="result" primary="true" serialization="map{'indent' : true()}" pipe="@final-report" />
  <p:output port="data" serialization="map{'indent' : true()}" sequence="true" />

  <p:variable name="main-directory-path" select="//dl4dh:request/@main-directory-path" />

  <p:variable name="service" select="//dl4dh:request/dl4dh:service[@name='Tei']" />

  <p:variable name="result-directory-path" select="concat($main-directory-path, $service/dl4dh:item[@name='nametag-tei-directory-path']/@value)">
   <p:documentation>Složka, do níž se uloží stažené dokumenty. Cesta ke složce může být absolutní i relativní.</p:documentation>
  </p:variable>
  <p:variable name="previous-step" select="/dl4dh:report/dl4dh:result/dl4dh:step[@service='NameTag' and @name='get-nametag-analyses']" />
  <p:variable name="previous-directory-path" select="$previous-step/@result-directory-path" />
  <p:variable name="items" select="$previous-step//dl4dh:item[@type='xml']" />


  <p:for-each name="loop">
   <p:with-input select="$items" />
   <p:output port="result" pipe="result@item-metadata" />
   <p:output port="data" primary="false" pipe="result@get-data" />

   <p:variable name="uuid" select="dl4dh:item/@uuid" />

   <p:variable name="file-name" select="concat($uuid, '.xml')" />
   <p:variable name="saved-file-path" select="p:urify(concat($result-directory-path, $file-name))" />

   <p:variable name="href" select="concat($previous-directory-path, dl4dh:item/@filename)" />

   <p:identity message="convert-nametag-items-to-tei: {$href} :: {$uuid}" />

   <dl4dh:convert-nametag-to-tei name="get-data">
    <p:with-input port="source" href="{$href}" />
   </dl4dh:convert-nametag-to-tei>

   <p:if test="$result-directory-path">
    <p:store href="{$saved-file-path}" />
   </p:if>

   <p:identity name="item-metadata">
    <p:with-input>
     <dl4dh:item uuid="{$uuid}" filename="{$file-name}" type="tei" />
    </p:with-input>
   </p:identity>

  </p:for-each>

  <p:identity name="data">
   <p:with-input port="source" pipe="data@loop" />
  </p:identity>


  <p:wrap-sequence wrapper="dl4dh:step">
   <p:with-input port="source" pipe="result@loop" />
   <p:documentation>Zabalení sekvence elementů <b>&lt;dl4dh:item&lt;</b> do nadřazeného elementu.</p:documentation>
  </p:wrap-sequence>
  <p:set-attributes match="/*" attributes="map{
   'service' : $service/@name, 
   'name' :  'convert-nametag-items-to-tei', 
   'result-directory-path' : $result-directory-path 
   }" />

  <p:identity name="metadata" />


  <p:insert match="dl4dh:report/dl4dh:result" position="last-child" name="final-report">
   <p:with-input port="source" pipe="source@convert-nametag-items-to-tei" />
   <p:with-input port="insertion" pipe="@metadata" />
  </p:insert>

 </p:declare-step>

 <p:declare-step type="dl4dh:convert-udpipe-to-tei">
  <p:input port="source" />
  <p:output port="result" />

  <p:variable name="udpipe-text" select="." />

  <p:xslt parameters="map{'input': $udpipe-text}" version="3.0">
   <p:with-input port="stylesheet" href="../Xslt/conllu-to-xml.xsl" />
  </p:xslt>

  <p:xslt version="2.0">
   <p:with-input port="stylesheet" href="../Xslt/conllu-xml-to-hierarchy.xsl"/>
  </p:xslt>

  <p:xslt version="2.0">
   <p:with-input port="stylesheet" href="../Xslt/conllu-xml-hierarchy-to-tei.xsl"/>
  </p:xslt>


 </p:declare-step>

 <p:declare-step type="dl4dh:convert-udpipe-items-to-tei" name="convert-udpipe-items-to-tei">

  <p:input port="source" xml:id="convert-udpipe-items-to-tei-input-source">
   <p:documentation>Metadata o zpracování.</p:documentation>
  </p:input>

  <p:output port="result" primary="true" serialization="map{'indent' : true()}" pipe="@final-report">
   <p:documentation>Metadata o zpracování doplněná o údaje z aktuálního kroku.</p:documentation>
  </p:output>

  <p:output port="data" serialization="map{'indent' : true()}" sequence="true">
   <p:documentation>Data ve formátu XML s rozpoznanými entitami pro jednotlivé strany.</p:documentation>
  </p:output>

  <p:variable name="main-directory-path" select="//dl4dh:request/@main-directory-path" />

  <p:variable name="service" select="//dl4dh:request/dl4dh:service[@name='Tei']" />

  <p:variable name="result-directory-path" select="concat($main-directory-path, $service/dl4dh:item[@name='udpipe-tei-directory-path']/@value)">
   <p:documentation>Složka, do níž se uloží stažené dokumenty. Cesta ke složce může být absolutní i relativní.</p:documentation>
  </p:variable>
  <p:variable name="previous-step" select="/dl4dh:report/dl4dh:result/dl4dh:step[@service='UDPipe' and @name='get-udpipe-analyses']" />
  <p:variable name="previous-directory-path" select="$previous-step/@result-directory-path" />
  <p:variable name="items" select="$previous-step//dl4dh:item[@type='txt']" />

  <p:for-each name="loop">
   <p:with-input select="$items" />
   <p:output port="result" pipe="result@item-metadata" />
   <p:output port="data" primary="false" pipe="result@get-data" />

   <p:variable name="uuid" select="dl4dh:item/@uuid" />

   <p:variable name="file-name" select="concat($uuid, '.xml')" />
   <p:variable name="saved-file-path" select="p:urify(concat($result-directory-path, $file-name))" />

   <p:variable name="href" select="concat($previous-directory-path, dl4dh:item/@filename)" />

<!--   <p:identity name="text">
    <p:with-input select="unparsed-text($href)" />
   </p:identity>-->
   
   <p:load href="{$href}" />

   <dl4dh:convert-udpipe-to-tei name="get-data" />
   
   <p:if test="$result-directory-path">
    <p:store href="{$saved-file-path}" />
   </p:if>

   <p:identity name="item-metadata">
    <p:with-input>
     <dl4dh:item uuid="{$uuid}" filename="{$file-name}" type="tei" />
    </p:with-input>
   </p:identity>

  </p:for-each>
  
  <p:identity name="data">
   <p:with-input port="source" pipe="data@loop" />
  </p:identity>


  <p:wrap-sequence wrapper="dl4dh:step">
   <p:with-input port="source" pipe="result@loop" />
   <p:documentation>Zabalení sekvence elementů <b>&lt;dl4dh:item&lt;</b> do nadřazeného elementu.</p:documentation>
  </p:wrap-sequence>
  <p:set-attributes match="/*" attributes="map{
   'service' : $service/@name, 
   'name' :  'convert-udpipe-items-to-tei', 
   'result-directory-path' : $result-directory-path 
   }" />
  
  <p:identity name="metadata" />

  <p:insert match="dl4dh:report/dl4dh:result" position="last-child" name="final-report">
   <p:documentation>Doplnění zprávy o zpracovaných prvcích.</p:documentation>
   <p:with-input port="source" pipe="source@convert-udpipe-items-to-tei" />
   <p:with-input port="insertion" pipe="@metadata" />
  </p:insert>


 </p:declare-step>

 <p:declare-step type="dl4dh:convert-items">
  <p:documentation>Konverze z jednoho formátu do druhého s pomocí XSLT transformací.</p:documentation>

  <p:input port="source" xml:id="convert-items-input-source">
   <p:documentation>Metadata o zpracování.</p:documentation>
  </p:input>

  <p:input port="source-data">
   <p:documentation>Vstupní data, která se mají zpracovat. Pokud nejsou k dispozici, načtou se pomocí údajů z metadat (viz <a href="#convert-items-input-source">source</a>).</p:documentation>
  </p:input>

  <p:output port="result" primary="true" serialization="map{'indent' : true()}"> <!-- pipe="@final-report" -->
   <p:documentation>Metadata o zpracování doplněná o údaje z aktuálního kroku.</p:documentation>
  </p:output>

  <p:output port="data" serialization="map{'indent' : true()}" sequence="true">
   <p:documentation>Data ve formátu XML s rozpoznanými entitami pro jednotlivé strany.</p:documentation>
  </p:output>

 </p:declare-step>
 
 <p:declare-step type="dl4dh:merge-tei-items" name="merge-tei-items">
  <p:documentation>Sloučení několika podob stejné stránky v TEI do jednoho dokumentu.</p:documentation>
  
  <p:input port="source" xml:id="merge-items-input-source">
   <p:documentation>Metadata o předchozím zpracování.</p:documentation>
  </p:input>
  
<!--  <p:input port="source-data">
   <p:documentation>Vstupní data, která se mají zpracovat. Pokud nejsou k dispozici, načtou se pomocí údajů z metadat (viz <a href="#convert-items-input-source">source</a>).</p:documentation>
  </p:input>-->
  
  <p:output port="result" primary="true" serialization="map{'indent' : true()}"> <!-- pipe="@final-report" -->
   <p:documentation>Metadata o zpracování doplněná o údaje z aktuálního kroku.</p:documentation>
  </p:output>
  
  <p:output port="data" serialization="map{'indent' : true()}" sequence="true">
   <p:documentation>Data ve formátu XML s rozpoznanými entitami pro jednotlivé strany.</p:documentation>
  </p:output>
  
  <p:variable name="main-directory-path" select="//dl4dh:request/@main-directory-path" />
  
  <p:variable name="service" select="//dl4dh:request/dl4dh:service[@name='Tei']" />
  
  <p:variable name="result-directory-path" select="concat($main-directory-path, $service/dl4dh:item[@name='tei-merge-directory-path']/@value)">
   <p:documentation>Složka, do níž se uloží výsledné dokumenty. Cesta ke složce může být absolutní i relativní.</p:documentation>
  </p:variable>

  <p:variable name="previous-step" select="/dl4dh:report/dl4dh:result/dl4dh:step[@service='Tei' and @name='convert-nametag-items-to-tei']" />
  <p:variable name="previous-directory-path" select="$previous-step/@result-directory-path" />
  <p:variable name="items" select="$previous-step//dl4dh:item[@type='tei']" />
  
  <p:variable name="previous-udpipe-step" select="/dl4dh:report/dl4dh:result/dl4dh:step[@service='Tei' and @name='convert-udpipe-items-to-tei']" />
  <p:variable name="previous-udpipe-directory-path" select="$previous-udpipe-step/@result-directory-path" />
  <p:variable name="udpipe-items" select="$previous-udpipe-step//dl4dh:item[@type='tei']" />
  
  
  <p:for-each name="loop">
   <p:with-input select="$items" />
   <p:output port="result" pipe="result@item-metadata" />
   <p:output port="data" primary="false" pipe="result@get-data" />
   
   <p:variable name="uuid" select="dl4dh:item/@uuid" />
   
   <p:variable name="file-name" select="concat($uuid, '.xml')" />
   <p:variable name="saved-file-path" select="p:urify(concat($result-directory-path, $file-name))" />
   
   <p:variable name="href" select="concat($previous-directory-path, dl4dh:item/@filename)" />
   <p:variable name="udpipe-href" select="concat($previous-udpipe-directory-path, $file-name)" />
   
   <!--   <p:identity name="text">
    <p:with-input select="unparsed-text($href)" />
   </p:identity>-->
   <p:load href="{$udpipe-href}" name="udpipe-file" />
   <p:variable name="udpipe-root" select="/*" />
   
   <p:load href="{$href}" />
   
   <p:xslt parameters="map{'udpipe': $udpipe-root}" version="3.0" name="get-data">
    <p:with-input port="stylesheet" href="../Xslt/merge-nametag-with-udpipe.xsl" />
   </p:xslt>
   
   <p:if test="$result-directory-path">
    <p:store href="{$saved-file-path}" />
   </p:if>
   
   <p:identity name="item-metadata">
    <p:with-input>
     <dl4dh:item uuid="{$uuid}" filename="{$file-name}" type="tei" />
    </p:with-input>
   </p:identity>
   
  </p:for-each>
  
  <p:identity name="data">
   <p:with-input port="source" pipe="data@loop" />
  </p:identity>
  
  
  <p:wrap-sequence wrapper="dl4dh:step">
   <p:with-input port="source" pipe="result@loop" />
   <p:documentation>Zabalení sekvence elementů <b>&lt;dl4dh:item&lt;</b> do nadřazeného elementu.</p:documentation>
  </p:wrap-sequence>
  <p:set-attributes match="/*" attributes="map{
   'service' : $service/@name, 
   'name' :  'merge-tei-items', 
   'result-directory-path' : $result-directory-path 
   }" />
  
  <p:identity name="metadata" />
  
  <p:insert match="dl4dh:report/dl4dh:result" position="last-child" name="final-report">
   <p:documentation>Doplnění zprávy o zpracovaných prvcích.</p:documentation>
   <p:with-input port="source" pipe="source@merge-tei-items" />
   <p:with-input port="insertion" pipe="@metadata" />
  </p:insert>
  
  
 </p:declare-step>

</p:library>
