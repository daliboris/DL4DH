<p:library xmlns:p="http://www.w3.org/ns/xproc" xmlns:xs="http://www.w3.org/2001/XMLSchema" 
 xmlns:dl4dh="https://system-kramerius.cz/ns/xproc/dl4dh/1.0"
 xmlns="http://www.w3.org/1999/xhtml" version="3.0">
 <p:documentation>
  <section>
   <p>Knihovna pro práci s formátem <a href="https://www.loc.gov/standards/alto/description.html" alt="ALTO">ALTO</a>.</p>
   <p>Knihovna obsahuje tyto kroky:</p>
   <dl>
    <dt>alto-to-tei</dt>
    <dd>převod z formátu <a href="https://www.loc.gov/standards/alto/description.html" alt="ALTO">ALTO</a> do formátu <a href="https://tei-c.org/release/doc/tei-p5-doc/en/html/index.html" alt="TEI Guidlines">TEI</a></dd>
   </dl>
  </section>
 </p:documentation>

 <p:declare-step type="dl4dh:convert-alto-to-tei" name="convert-alto-to-tei" version="3.0">
  <p:input port="source" />
  <p:output port="result" />
  
  
   <p:xslt version="2.0" message="Transforming from ALTO to TEI">
     <p:with-input port="stylesheet" href="../Xslt/alto2tei.xsl" />
   </p:xslt>
  
 </p:declare-step>
 
 <p:declare-step type="dl4dh:convert-alto-items-to-tei" name="convert-alto-items-to-tei" version="3.0">
  <p:documentation></p:documentation>
  
  <p:input port="source" />
  <p:output port="result" primary="true" serialization="map{'indent' : true()}" pipe="@final-report" />
  <p:output port="data" serialization="map{'indent' : true()}" sequence="true" />

  <p:variable name="main-directory-path" select="//dl4dh:request/@main-directory-path" />
  
  <p:variable name="service" select="//dl4dh:request/dl4dh:service[@name='Alto']" />
  
  <p:variable name="result-directory-path" select="concat($main-directory-path, $service/dl4dh:item[@name='tei-directory-path']/@value)">
   <p:documentation>Složka, do níž se uloží stažené dokumenty. Cesta ke složce může být absolutní i relativní.</p:documentation>
  </p:variable>
  <p:variable name="previous-step" select="/dl4dh:report/dl4dh:result/dl4dh:step[@service='Kramerius' and @name='get-alto-pages']" />
  <p:variable name="previous-directory-path" select="$previous-step/@result-directory-path" />
  <p:variable name="items" select="$previous-step//dl4dh:item[@type='alto']" />

  <p:for-each name="loop">
   <p:with-input select="$items" />
   <p:output port="result" pipe="result@item-metadata" />
   <p:output port="data" primary="false" pipe="result@get-data"/>

   <p:variable name="uuid" select="dl4dh:item/@uuid" />
   
   <p:variable name="file-name" select="concat($uuid, '.xml')" />
   <p:variable name="saved-file-path" select="p:urify(concat($result-directory-path, $file-name))"/>

   <p:variable name="href" select="concat($previous-directory-path, dl4dh:item/@filename)" />

   <p:identity message="convert-alto-items-to-tei {$href} :: {$uuid}" />

   <dl4dh:convert-alto-to-tei name="get-data">
    <p:with-input port="source" href="{$href}" />
   </dl4dh:convert-alto-to-tei>

   <p:if test="$result-directory-path">
    <p:store href="{$saved-file-path}" /> 
   </p:if>
   
   <p:identity name="item-metadata">
    <p:with-input>
     <dl4dh:item uuid="{$uuid}" filename="{$file-name}" type="tei"/>
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
   'name' :  'convert-alto-items-to-tei', 
   'result-directory-path' : $result-directory-path 
   }" />
  
  <p:identity name="metadata" />

  <p:insert match="dl4dh:report/dl4dh:result" position="last-child" name="final-report">
   <p:documentation>Doplnění zprávy o zpracovaných prvcích.</p:documentation>
   <p:with-input port="source" pipe="source@convert-alto-items-to-tei" />
   <p:with-input port="insertion" pipe="@metadata"/>
  </p:insert>


 </p:declare-step>

</p:library>
