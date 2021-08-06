<p:library xmlns:p="http://www.w3.org/ns/xproc" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:foxml="info:fedora/fedora-system:def/foxml#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:or="http://www.nsdl.org/ontologies/relationships#"
 xmlns:dl4dh="https://system-kramerius.cz/ns/xproc/dl4dh/1.0" xmlns="http://www.w3.org/1999/xhtml" version="3.0">

 <p:documentation>
  <section>
   <p>Knihovna pro práci s rozhraním systému <a href="https://system-kramerius.cz" alt="Kramerius">Kramerius</a>.</p>
   <p>Účelem knihovny je stáhnout požadovanou publikaci na základě jejího identifikátoru <a href="#get-foxml-uuid">uuid</a>. Stáhnout se všechny její strany z repozitáře konkrétní instance Kraméria, která je identifikovaná pomocí odkazu <b>base-url</b>.</p>
  </section>
 </p:documentation>

 <p:declare-step type="dl4dh:get-foxml" name="get-foxml">
  <p:documentation>
   <section>
    <p>Stažení dokumentu ve standardu <a href="https://wiki.lyrasis.org/pages/viewpage.action?pageId=30221134" alt="Standard FOXML">FOXML</a> (Fedora Object XML), který obsahuje metadata k jedné publikaci.</p>
   </section>
  </p:documentation>

  <p:input port="source">
   <p:documentation>
    <section>
     <p>Požadavek na zpracování. Dokument XML ve jmenném prostoru <b>https://system-kramerius.cz/ns/xproc/dl4dh/1.0</b>, který obshauje element <b>request</b> s nezbytnými údaji.</p>
     <pre lang="xml">
      <service name="Kramerius">
       <item name="base-url" value="https://dnnt.mzk.cz/search/api/v5.0/item/" />
       <item name="uuid" value="84e676e0-a796-11e9-9209-005056827e51" />
       <item name="foxml-directory-path" value="Foxml/" />
       <item name="alto-directory-path" value="Alto/" />
      </service>
     </pre>
    </section>
   </p:documentation>
  </p:input>
  <p:output port="result" primary="true" serialization="map{'indent' : true()}" pipe="@final-report"> <!-- @final-report -->
   <p:documentation>
    <section>
     <p>Primární výstupní port. Obsahuje metadata o provedených operacích a získaných dokumentech. Údaje se zaznamnávají do dokumentu XML ve jmenném prostoru <b>https://system-kramerius.cz/ns/xproc/dl4dh/1.0</b>. Viz ukázka:</p>
     <pre lang="xml">
      <report xmlns="https://system-kramerius.cz/ns/xproc/dl4dh/1.0">
       <request>
        <service name="Kramerius">
         <item name="base-url" value="https://dnnt.mzk.cz/search/api/v5.0/item/" />
         <item name="uuid" value="84e676e0-a796-11e9-9209-005056827e51" />
         <item name="foxml-directory-path" value="Foxml/" />
         <item name="alto-directory-path" value="Alto/" />
        </service>
      </request>
      <result>
       <step name="get-foxml" href="file:///D:/Data/...">
        <uuids>
         <uuid>98312b4b-acec-4646-a450-13cfdc516621</uuid>
        </uuids>
       </step>
      </result>
     </report>
     </pre>
    </section>
   </p:documentation>
  </p:output>
  
  <p:output port="data" serialization="map{'indent' : true()}" pipe="@get-data"/>


  <p:variable name="main-directory-path" select="//dl4dh:request/@main-directory-path" />
  
  <p:variable name="service" select="//dl4dh:request/dl4dh:service[@name='Kramerius']" />
 
  <p:variable name="base-url" select="$service/dl4dh:item[@name='base-url']/@value">
   <p:documentation>URL instanace Kraméria, která obsahuje požadovanou publikaci.</p:documentation>
  </p:variable>
  
  <p:variable name="uuid" select="$service/dl4dh:item[@name='uuid']/@value">
   <p:documentation>Jedinečný identifikátor, který identifikuje požadovanou publikaci.</p:documentation>
  </p:variable>

  <p:variable name="result-directory-path" select="concat($main-directory-path, $service/dl4dh:item[@name='foxml-directory-path']/@value)">
   <p:documentation>Složka, do níž se uloží stažené dokumenty. Cesta ke složce může být absolutní i relativní.</p:documentation>
  </p:variable>


  <p:variable name="file-name" select="concat($uuid, '.xml')"></p:variable>
  <p:variable name="saved-file-path" select="p:urify(concat($result-directory-path, $file-name))"/>

  <p:variable name="foxml-url" select="concat($base-url, 'uuid:', $uuid, '/foxml')"/>

  <p:http-request message="Downloading {$foxml-url}" href="{$foxml-url}" name="get-data"/>

  <p:if test="$result-directory-path">
   <p:store href="{$saved-file-path}" message="Saving {$saved-file-path}"/>
  </p:if>

  <dl4dh:get-page-uuids name="page-uuids"/>

  <p:identity name="report">
   <p:with-input>
     <dl4dh:step name="get-foxml" service="{$service/@name}" result-directory-path="{$result-directory-path}">
      <dl4dh:item uuid="{$uuid}" type="foxml" filename="{$file-name}" /> 
     </dl4dh:step>
   </p:with-input>
  </p:identity>

  <p:insert match="//dl4dh:result" position="last-child">
   <p:with-input port="source" pipe="source@get-foxml"/>
   <p:with-input port="insertion" pipe="result@report"/>
  </p:insert>

  <p:insert match="//dl4dh:result/dl4dh:step[@service='{$service/@name}' and @name='get-foxml']" position="last-child">
   <p:with-input port="source"/>
   <p:with-input port="insertion" pipe="result@page-uuids"/>
  </p:insert>

  <p:identity name="final-report"/>

 </p:declare-step>

 <p:declare-step type="dl4dh:get-page-uuids">
  <p:documentation>
   <section>
    <p>Ze vstupního dokumentu <b>FOXML</b> získá identifikátory stran.</p>
   </section>
  </p:documentation>

  <p:input port="source"/>
  <p:output port="result" serialization="map{'indent' : true()}"/>

  <p:xslt version="2.0">
   <p:with-input port="stylesheet" href="../Xslt/foxml-to-uuids.xsl"/>
  </p:xslt>
 </p:declare-step>

 <p:declare-step type="dl4dh:get-alto-pages" name="get-alto-pages">
  <p:documentation></p:documentation>
  
  <p:input port="source" primary="true"/>
  <p:output port="result" primary="true" serialization="map{'indent' : true()}" pipe="@final-report"/>
  <p:output port="data" serialization="map{'indent' : true()}" sequence="true"/>

  <p:variable name="main-directory-path" select="//dl4dh:request/@main-directory-path" />
  
  <p:variable name="service" select="//dl4dh:request/dl4dh:service[@name='Kramerius']" />
 
  <p:variable name="base-url" select="$service/dl4dh:item[@name='base-url']/@value">
   <p:documentation>URL instanace Krameria, která obsahuje požadovanou publikaci.</p:documentation>
  </p:variable>
  
  <p:variable name="result-directory-path" select="concat($main-directory-path, $service/dl4dh:item[@name='alto-directory-path']/@value)">
   <p:documentation>Složka, do níž se uloží stažené dokumenty. Cesta ke složce může být absolutní i relativní.</p:documentation>
  </p:variable>

  <p:for-each name="loop">
   <p:with-input select="/dl4dh:report/dl4dh:result/dl4dh:step[@service=$service/@name and @name='get-foxml']//dl4dh:uuid"/>
   <p:output port="result" pipe="result@item-metadata"/>
   <p:output port="data" primary="false" pipe="result@get-data"/>

   <p:variable name="uuid" select="string(.)"/>
   <p:variable name="file-name" select="concat($uuid, '.xml')" />
   <p:variable name="saved-file-path" select="p:urify(concat($result-directory-path, $file-name))"/>
   <p:variable name="url" select="concat($base-url, 'uuid:', $uuid, '/streams/ALTO')" />

   <p:http-request href="{$url}" name="get-data" /> <!-- message="Downloading {$url}" -->

   <p:if test="$result-directory-path">
    <p:store href="{$saved-file-path}" /> <!-- message="Saving {$saved-file-path}" -->
   </p:if>

   <!-- href="{$saved-file-path}" -->
   <p:identity name="item-metadata">
    <p:with-input>
     <dl4dh:item uuid="{$uuid}" filename="{$file-name}" type="alto"/>
    </p:with-input>
   </p:identity>

  </p:for-each>
  
  <p:identity name="data">
   <p:with-input port="source" pipe="data@loop" />
  </p:identity>

  <p:wrap-sequence wrapper="dl4dh:step">
   <p:with-input port="source" pipe="result@loop" />
  </p:wrap-sequence>
  <p:set-attributes match="/*" attributes="map{
   'service' : $service/@name, 
   'name' :  'get-alto-pages', 
   'result-directory-path' : $result-directory-path 
   }" />
   
  <p:identity name="metadata" />

  <p:insert match="dl4dh:report/dl4dh:result" position="last-child" name="final-report">
   <p:with-input port="source" pipe="source@get-alto-pages"/>
   <p:with-input port="insertion" pipe="@metadata"/>
  </p:insert>


 </p:declare-step>

</p:library>
