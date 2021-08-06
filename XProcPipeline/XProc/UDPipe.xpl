<p:library xmlns:p="http://www.w3.org/ns/xproc" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dl4dh="https://system-kramerius.cz/ns/xproc/dl4dh/1.0" xmlns="http://www.w3.org/1999/xhtml" version="3.0">

 <p:documentation>
  <section>
   <p>Knihovna pro práci s aplikací <a href="https://ufal.mff.cuni.cz/udpipe" alt="UDPipe">UDPipe</a>, respektive s jejím RESTovvým rozhraním na adrese <a href="https://lindat.mff.cuni.cz/services/udpipe/api/process" alt="API UDPipe">https://lindat.mff.cuni.cz/services/udpipe/api/process</a>.</p>
   <p>UDPipe chápe jako hranici odstavce dva znaky nové řádky za sebou (tj. prázdné řádky).</p>

   <p>Knihovna obsahuje tyto kroky:</p>
   <dl itemscope="itemscope" itemtype="https://system-kramerius.cz/ns/xproc/documentation/library">

    <dt itemprop="step">
     <span itemprop="name">udpipe-text-to-xml</span>
    </dt>
    <dd itemprop="description">převod prostého textu do formátu XML</dd>

    <dt itemprop="step">
     <span itemprop="name">udpipe-files-to-xml</span>
    </dt>
    <dd itemprop="description">převod textových souborů do souborů ve formátu XML</dd>

   </dl>
  </section>
  <section>
   <p>Při zpracování dat je potřeba dodržovat licenční podmínky této služby.</p>
   <p>The service is freely available for testing. Respect the <a href="http://creativecommons.org/licenses/by-nc-sa/4.0/">CC BY-NC-SA</a> licence of the models – <b>explicit written permission of the authors is required for any commercial exploitation of the system</b>. If you use the service, you agree that data obtained by us during such use can be used for further improvements of the systems at UFAL. All comments and reactions are welcome.</p>
  </section>
 </p:documentation>

 <p:declare-step type="dl4dh:get-udpipe-analysis" version="3.0">

  <p:documentation>
   <section>
    <p>Analyzuje vstupní text nástrojem <b>UDPipe</b>, výsledek uloží v podobě dokumentů ve formátu XML a TXT.</p>
    <p>Zavolá API služby NameTag, předá jí text k rozpoznání a výsledek (dokument JSON) převede pomocí XSLT transformace na text a validní XML.</p>
   </section>
   <section itemscope="itemscope" itemtype="https://system-kramerius.cz/ns/xproc/documentation/step">
    <p itemprop="option">
     <span itemprop="name">url</span>: <span itemprop="description">URL adresa RESTového API (včetně hlavních parametrů).</span>
    </p>
   </section>
  </p:documentation>

  <p:option name="url" select="'https://lindat.mff.cuni.cz/services/udpipe/api/process?tokenizer&amp;tagger&amp;parser&amp;data='">
   <p:documentation>URL adresa RESTového API (včetně hlavních parametrů).</p:documentation>
  </p:option>

  <p:input port="source">
   <p:documentation>Prostý text, který má aplikace <b>UDPipe</b> zpracovat a opatřit morfosyntaktickou anotací.</p:documentation>
  </p:input>

  <p:output port="result" serialization="map{'indent' : true()}">
   <p:documentation>Obsahuje morfologickou anotaci vstupního textu ve formátu JSON.</p:documentation>
  </p:output>

  <!-- <p:variable name="lines" select="tokenize(., '\n')">
   <p:documentation>Rozdělení textu na řády, de facto odstavce.</p:documentation>
  </p:variable>
   
  <p:for-each>
   <p:with-input select="$lines" />
   <p:output pipe="result@request"/>
   <p:variable name="text" select="encode-for-uri(.)" />
   <p:http-request 
    name="request"
    message="Downloading UDPipe"
    href="{concat($url,$text)}"
    parameters="map{ 'override-content-type' : 'application/json' }" />
   
  </p:for-each>-->

  <p:variable name="max-length" select="2600" />
  <p:variable name="plain-text" select="if(string-length(.) gt $max-length) then substring(., 1, $max-length) else ." />
  <p:variable name="text" select="encode-for-uri($plain-text)" />
  

  <p:http-request message="Downloading UDPipe" href="{concat($url,$text)}" parameters="map{ 'override-content-type' : 'application/json' }">
   <p:documentation>Volání API služby <b>UDPipe</b> pomocí metody<b>GET</b>. Jako vstupní parametr služby se předává prostý text, kódovaný pro URI.</p:documentation>
   <!--<p:with-option name="href" select="concat($url,encode-for-uri($text))" />-->
  </p:http-request>

 </p:declare-step>

 <p:declare-step type="dl4dh:get-udpipe-analyses" version="3.0" name="get-udpipe-analyses">
  <p:documentation>Na základě metadat o zpracování odesílá textová data jednotlivých stran publikace na RESTové rozhraní služby <a href="https://ufal.mff.cuni.cz/udpipe" alt="UDPipe">UDPipe</a>, čímž získá obohacený, morfosyntakticky anotovaný výstup ve formátu <a href="https://universaldependencies.org/format.html" alt="Specifikace formátu CoNNL-U">CoNNL-U</a>.</p:documentation>

  <p:input port="source">
   <p:documentation>Metadata o zpracování předchozích kroků.</p:documentation>
  </p:input>

  <p:output port="result" primary="true" serialization="map{'indent' : true()}" pipe="@final-report">
   <p:documentation>Metadata o zpracování doplněná o údaje z aktuálního kroku.</p:documentation>
  </p:output>

  <p:output port="data" serialization="map{'indent' : true()}" sequence="true">
   <p:documentation>Data ve formátu TXT s morfosyntaktickou anotací tokenů pro jednotlivé strany.</p:documentation>
  </p:output>

  <p:variable name="main-directory-path" select="//dl4dh:request/@main-directory-path" />
  
  <p:variable name="service" select="//dl4dh:request/dl4dh:service[@name='UDPipe']" />
  
  <p:variable name="result-directory-path" select="concat($main-directory-path, $service/dl4dh:item[@name='udpipe-text-directory-path']/@value)">
   <p:documentation>Složka, do níž se uloží stažené dokumenty. Cesta ke složce může být absolutní i relativní.</p:documentation>
  </p:variable>
  
  <p:variable name="result-directory-path-xml" select="concat($main-directory-path, $service/dl4dh:item[@name='udpipe-xml-directory-path']/@value)">
   <p:documentation>Složka, do níž se uloží stažené dokumenty. Cesta ke složce může být absolutní i relativní.</p:documentation>
  </p:variable>
  
  <p:variable name="previous-step" select="/dl4dh:report/dl4dh:result/dl4dh:step[@service='Tei' and @name='convert-tei-items-to-text']" />
  <p:variable name="previous-directory-path" select="$previous-step/@result-directory-path" />
  <p:variable name="items" select="$previous-step//dl4dh:item[@type='txt']" />

  <p:variable name="service-url" select="$service/dl4dh:item[@name='udpipe-url']/@value">
   <p:documentation>URL RESTové služby.</p:documentation>
  </p:variable>

  <p:for-each name="loop">
   <p:documentation>Zpracuje jednotlivé identifikátory ze vstupního seznamu.</p:documentation>

   <p:with-input select="$items" />
   <p:output port="result" pipe="result@item-metadata" />
   <p:output port="data" primary="false" pipe="result@get-data" />
   <!-- do metadat se přidávají 2 položky: pro XML a TXT -->

   <p:variable name="uuid" select="dl4dh:item/@uuid" />
   
   <p:variable name="file-name" select="concat($uuid, '.txt')" />
   <p:variable name="file-name-xml" select="concat($uuid, '.xml')" />
   <p:variable name="saved-file-path" select="p:urify(concat($result-directory-path, $file-name))"/>
   <p:variable name="saved-file-path-xml" select="p:urify(concat($result-directory-path-xml, $file-name-xml))"/>

   <p:variable name="href" select="concat($previous-directory-path, dl4dh:item/@filename)" />

   <p:identity name="text">
    <p:documentation>Načte obsah textového dokumentu.</p:documentation>

    <p:with-input select="unparsed-text($href)"/>
   </p:identity>

   <dl4dh:get-udpipe-analysis>
    <p:documentation>
     <p>Text nechá zpracovat nástrojem <b>UDPipe</b>. Výstupy se uloží v rámci samotného zpracování.</p>
    </p:documentation>

    <p:with-option name="url" select="$service-url"/>
   </dl4dh:get-udpipe-analysis>

   <p:identity>
    <p:documentation>Převod formátu JSON do XML bez zbytečných escapvaných textů.</p:documentation>
    <p:with-input port="source">
     <dl4dh:result source="UDPipe">{?result}</dl4dh:result>
    </p:with-input>
   </p:identity>

   <p:xslt name="get-data">
    <p:documentation>Transformace výstupního dokumentu na prostý text.</p:documentation>

    <p:with-input port="stylesheet" href="../Xslt/udpipe-json-to-text.xsl"/>
   </p:xslt>

   <p:if test="$result-directory-path">
    <p:store href="{$saved-file-path}" />
   </p:if>

   <p:identity name="item-metadata">
    <p:with-input>
     <dl4dh:item uuid="{$uuid}" filename="{$file-name}" type="txt"/>
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
   'name' :  'get-udpipe-analyses', 
   'result-directory-path' : $result-directory-path 
   }" />
  
  <p:identity name="metadata" />

  <p:insert match="dl4dh:report/dl4dh:result" position="last-child" name="final-report">
   <p:documentation>Doplnění zprávy o zpracovaných prvcích.</p:documentation>
   <p:with-input port="source" pipe="source@get-udpipe-analyses"/>
   <p:with-input port="insertion" pipe="@metadata"/>
  </p:insert>

 </p:declare-step>

</p:library>
