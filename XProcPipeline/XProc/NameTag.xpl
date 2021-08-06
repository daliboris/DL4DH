<p:library xmlns:p="http://www.w3.org/ns/xproc"
 xmlns:xs="http://www.w3.org/2001/XMLSchema" 
 xmlns:c="http://www.w3.org/ns/xproc-step"
 xmlns:dl4dh="https://system-kramerius.cz/ns/xproc/dl4dh/1.0" xmlns="http://www.w3.org/1999/xhtml" version="3.0">

 <p:documentation>
  <section>
   <p>Knihovna pro práci s aplikací <a href="https://ufal.mff.cuni.cz/nametag/2" alt="NameTag">NameTag</a>, respektive s jejím RESTovvým rozhraním na adrese <a href="http://lindat.mff.cuni.cz/services/nametag/api/recognize?data=" alt="NameTag API">http://lindat.mff.cuni.cz/services/nametag/api/</a>.</p>
  </section>
  <section>
   <p>Při zpracování dat je potřeba dodržovat licenční podmínky této služby.</p>
   <p>The associated models and data are licensed under <a href="http://creativecommons.org/licenses/by-nc-sa/4.0/">CC BY-NC-SA</a>, although for some models the original data used to create the model may impose additional licensing conditions.</p>
   <p>If you use this tool for scientific work, please give us credit by referencing <a href="http://ufal.mff.cuni.cz/nametag">NameTag website</a> and <a href="https://www.aclweb.org/anthology/P19-1527.pdf">Straková et al. 2019</a> (see <a href="https://ufal.mff.cuni.cz/nametag/2#publications">BibTeX for referencing</a>).</p>
  </section>
 </p:documentation>

 <p:declare-step type="dl4dh:get-nametag-analysis" version="3.0">
  <p:documentation>
   <section>
    <p>Převede vstupní text na dokument ve formátu XML.</p>
    <p>Zavolá API služby NameTag, předá jí text k rozpoznání a výsledek (dokument JSON) převede pomocí XSLT transformace na validní XML.</p>
   </section>
  </p:documentation>

  <p:input port="source">
   <p:documentation>Prostý text, který má aplikace NameTag zpracovat a rozpoznat v něm entity.</p:documentation>
  </p:input>

  <p:output port="result" serialization="map{'indent' : true()}">
   <p:documentation>Obsahuje reprezentaci rozpoznaných entit ve formátu XML.</p:documentation>
  </p:output>

  <p:option name="url" select="'http://lindat.mff.cuni.cz/services/nametag/api/recognize?data='">
   <p:documentation>URL adresa RESTového API služby</p:documentation>
  </p:option>

<!--  <p:option name="uri" select="'http://lindat.mff.cuni.cz/services/nametag/api/recognize'" />-->
  <p:variable name="max-length" select="2600" />
  <p:variable name="plain-text" select="if(string-length(.) gt $max-length) then substring(., 1, $max-length) else ." />
  <p:variable name="text" select="encode-for-uri($plain-text)" />

  <!--  <p:http-request href="{$uri}" method="POST" message="{$uri}">
   <p:with-input>
    <c:request >
     <c:multipart content-type="multipart/form-data" boundary="-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-827391814405806938725830">
      <c:body content-type="plain/text" disposition='form-data; name="data"'>TEXT</c:body>
     </c:multipart>
    </c:request>
   </p:with-input>
  </p:http-request>-->

  <p:http-request href="{concat($url,$text)}">
   <!--<p:with-option name="method" select="'POST'" />-->
   <p:documentation>
    <section>
     <p>Volání API služby NameTag pomocí metody<b>GET</b>. Jako vstupní parametr služby se předává prostý text, kódovaný pro URI.</p>
    </section>
   </p:documentation>

   <!--<p:with-option name="href" select="concat($url,$text)"/>-->
  </p:http-request>

 </p:declare-step>

 <p:declare-step type="dl4dh:convert-nametag-analysis-to-xml">

  <p:input port="source" content-types="application/json" />
  <p:output port="result" content-types="application/xml" />
  
  <p:variable name="model" select="normalize-space(?model)" />

  <p:cast-content-type content-type="application/xml">
   <p:with-input port="source" select="?result" />
  </p:cast-content-type>

  <p:xslt version="3.0">
   <p:with-input port="stylesheet">
    <p:inline>
     <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0">
      <xsl:output method="text" />
      <xsl:variable name="ns" select="concat('xmlns:dl4dh=', '&#x22;', 'https://system-kramerius.cz/ns/xproc/dl4dh/1.0', '&#x22;')" />
      <xsl:template match="/">
       <xsl:variable name="text">
        <xsl:value-of select="string(/*/.) => replace('\\\\r\\\\n', '') => normalize-space()" />
       </xsl:variable>
       <xsl:value-of select="concat('&lt;dl4dh:result source=', '&#x22;', 'NameTag', '&#x22;', ' ', $ns ,'&gt;', $text, '&lt;/dl4dh:result&gt;')" />
      </xsl:template>
     </xsl:stylesheet>
    </p:inline>
   </p:with-input>
  </p:xslt>

  <p:cast-content-type content-type="application/xml" />
  
  <p:choose>
   <p:when test=". instance of node()">
    <p:add-attribute attribute-name="model" attribute-value="{$model}" />
   </p:when>
   <p:otherwise>
    <p:identity>
     <p:with-input port="source">
      <p:inline><dl4dh:result source="NameTag" /></p:inline>
     </p:with-input>
    </p:identity>    
   </p:otherwise>
  </p:choose>

 </p:declare-step>

 <p:declare-step type="dl4dh:get-nametag-analyses" name="get-nametag-analyses" version="3.0">
  <p:documentation>Na základě metadat o zpracování odesílá textová data jednotlivých stran publikace na RESTové rozhraní služby <a href="https://ufal.mff.cuni.cz/nametag/2" alt="NameTag">NameTag</a>, výsledky konvertuje do formátu XML a ukládá do složky.</p:documentation>

  <p:input port="source">
   <p:documentation>Metadata o zpracování.</p:documentation>
  </p:input>

  <p:output port="result" primary="true" serialization="map{'indent' : true()}" pipe="@final-report">
   <p:documentation>Metadata o zpracování doplněná o údaje z aktuálního kroku.</p:documentation>
  </p:output>

  <p:output port="data" serialization="map{'indent' : true()}" sequence="true">
   <p:documentation>Data ve formátu XML s rozpoznanými entitami pro jednotlivé strany.</p:documentation>
  </p:output>

  <p:variable name="main-directory-path" select="//dl4dh:request/@main-directory-path" />
  
  <p:variable name="service" select="//dl4dh:request/dl4dh:service[@name='NameTag']" />
  
  <p:variable name="result-directory-path" select="concat($main-directory-path, $service/dl4dh:item[@name='nametag-directory-path']/@value)">
   <p:documentation>Složka, do níž se uloží stažené dokumenty. Cesta ke složce může být absolutní i relativní.</p:documentation>
  </p:variable>
  <p:variable name="previous-step" select="/dl4dh:report/dl4dh:result/dl4dh:step[@service='Tei' and @name='convert-tei-items-to-text']" />
  <p:variable name="previous-directory-path" select="$previous-step/@result-directory-path" />
  <p:variable name="items" select="$previous-step//dl4dh:item[@type='txt']" />

  <p:variable name="service-url" select="$service/dl4dh:item[@name='nametag-url']/@value">
   <p:documentation>URL RESTové služby.</p:documentation>
  </p:variable>


  <p:for-each name="loop">
   <p:with-input select="$items" />
   <p:output port="result" pipe="result@item-metadata" />
   <p:output port="data" primary="false" pipe="result@get-data"/>

   <p:variable name="uuid" select="dl4dh:item/@uuid" />
   
   <p:variable name="file-name" select="concat($uuid, '.xml')" />
   <p:variable name="saved-file-path" select="p:urify(concat($result-directory-path, $file-name))"/>

   <p:variable name="href" select="concat($previous-directory-path, dl4dh:item/@filename)" />

   <p:identity name="text">
    <p:with-input select="unparsed-text($href)" />
   </p:identity>

   <dl4dh:get-nametag-analysis p:message="get-nametag-analysis {$uuid}">
    <p:with-option name="url" select="$service-url" />
   </dl4dh:get-nametag-analysis>

   <dl4dh:convert-nametag-analysis-to-xml name="get-data"/>

   <p:if test="$result-directory-path">
    <p:store href="{$saved-file-path}" />
   </p:if>

   <p:identity name="item-metadata">
    <p:with-input>
     <dl4dh:item uuid="{$uuid}" filename="{$file-name}" type="xml"/>
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
   'name' :  'get-nametag-analyses', 
   'result-directory-path' : $result-directory-path 
   }" />
  
  <p:identity name="metadata" />

  <p:insert match="dl4dh:report/dl4dh:result" position="last-child" name="final-report">
   <p:documentation>Doplnění zprávy o zpracovaných prvcích.</p:documentation>
   <p:with-input port="source" pipe="source@get-nametag-analyses" />
   <p:with-input port="insertion" pipe="@metadata" />
  </p:insert>

 </p:declare-step>

</p:library>
