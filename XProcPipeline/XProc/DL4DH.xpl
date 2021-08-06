<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dl4dh="https://system-kramerius.cz/ns/xproc/dl4dh/1.0" version="3.0">

 <p:import href="Kramerius.xpl"/>
 <p:import href="Alto.xpl"/>
 <p:import href="Tei.xpl"/>
 <p:import href="NameTag.xpl"/>
 <p:import href="UDPipe.xpl"/>

 <!--
  bd3b89f0-1396-11eb-a4cf-005056827e52 (Protokol ... veřejné schůze bratrstva sv. Michala v Praze dne, 1898)
  84e676e0-a796-11e9-9209-005056827e51 (Vznik a uznání Československého státu, 1926)
 -->

 <p:input port="source">
  <p:inline>
   <report xmlns="https://system-kramerius.cz/ns/xproc/dl4dh/1.0">
    <request debug="true"
     main-directory-path="file:/D:/Temp/DL4DH/XProc/Xml/"> <!-- TODO: nastavit složku, do níž se ukládají (mezi)výsledky  -->
     <service name="Kramerius">
      <item name="base-url" value="https://dnnt.mzk.cz/search/api/v5.0/item/" />
      <!--<item name="uuid" value="84e676e0-a796-11e9-9209-005056827e51" />--> <!-- (Vznik a uznání Československého státu, 1926) -->
      <!--<item name="uuid" value="bd3b89f0-1396-11eb-a4cf-005056827e52" />--> <!-- (Protokol ... veřejné schůze bratrstva sv. Michala v Praze dne, 1898); ve FOXML neexistují odkazy na ALTO -->
      <item name="uuid" value="3c4c3540-3130-11ea-b0e3-005056827e52" /> <!-- Washingtonská deklarace -->
      <item name="foxml-directory-path" value="Foxml/" />
      <item name="alto-directory-path" value="Alto/" />
     </service>
     <service name="Alto">
      <item name="tei-directory-path"  value="Tei/Xml/"  />
      <item name="tei-text-directory-path"  value="Tei/Text/"  />
     </service>
     <service name="Tei">
      <item name="tei-directory-path"  value="Tei/Xml/"  />
      <item name="tei-text-directory-path"  value="Tei/Text/"  />
      <item name="tei-merge-directory-path"  value="Tei/Merge/"  />
      <item name="nametag-tei-directory-path"  value="NameTag/Tei/"  />
      <item name="udpipe-tei-directory-path"  value="UDPipe/Tei/"  />
     </service>
     <service name="NameTag">
      <item name="nametag-url" value="http://lindat.mff.cuni.cz/services/nametag/api/recognize?data=" />
      <item name="nametag-directory-path"  value="NameTag/Xml/"  />
      <item name="nametag-tei-directory-path"  value="NameTag/Tei/"  />
     </service>
     <service name="UDPipe">
      <item name="udpipe-url" value="https://lindat.mff.cuni.cz/services/udpipe/api/process?tokenizer&amp;tagger&amp;parser&amp;data=" />
      <item name="udpipe-directory-path"  value="UDPipe/Xml/" />
      <item name="udpipe-text-directory-path"  value="UDPipe/Text/" />
      <item name="udpipe-tei-directory-path"  value="UDPipe/Tei/" />
     </service>
    </request>
    <result />
   </report>
  </p:inline>
 </p:input>

 <p:output port="result" sequence="true" serialization="map{'indent' : true()}"/>

 <p:variable name="main-directory-path" select="concat(/dl4dh:report/dl4dh:request/@main-directory-path, 'Report/')"/>
 
 <p:variable name="debug" select="dl4dh:report/dl4dh:request/@debug" />

 <dl4dh:get-foxml name="get-foxml" p:message="get-foxml"/>

 <p:store href="{$main-directory-path}report.xml" message="Storing {$main-directory-path}report.xml" serialization="map{'indent' : true()}"/>

 <dl4dh:get-alto-pages name="get-alto-pages" p:message="get-alto-pages"/>

 <p:store href="{$main-directory-path}report-alto.xml" message="Storing {$main-directory-path}report-alto.xml" serialization="map{'indent' : true()}" />


 <dl4dh:convert-alto-items-to-tei name="convert-alto-items-to-tei"/>

 <p:store href="{$main-directory-path}report-tei.xml" message="Storing {$main-directory-path}report-tei.xml" serialization="map{'indent' : true()}" />


 <dl4dh:convert-tei-items-to-text name="convert-tei-items-to-text"/>

 <p:store href="{$main-directory-path}report-convert-tei-items-to-text.xml" message="Storing {$main-directory-path}report-convert-tei-items-to-text.xml" serialization="map{'indent' : true()}" />
 

 
<!-- <p:load href="{$main-directory-path}report-tei-text.xml" message="Loading {$main-directory-path}report-tei-text.xml" />-->
 
 <dl4dh:get-nametag-analyses/>
 
 <p:store href="{$main-directory-path}report-nametag-analyses.xml" message="Storing {$main-directory-path}report-nametag-analyses.xml"/>
 

<!-- <p:load href="{$main-directory-path}/report-nametag-analyses.xml" message="Loading {$main-directory-path}/report-nametag-analyses.xml" />-->
 
 <dl4dh:convert-nametag-items-to-tei />

 <p:store href="{$main-directory-path}report-convert-nametag-items-to-tei.xml" message="Storing {$main-directory-path}report-convert-nametag-items-to-tei.xml"/>
 
 
<!-- <p:load href="{$main-directory-path}/report-convert-nametag-items-to-tei.xml" message="Loading {$main-directory-path}/report-convert-nametag-items-to-tei.xml" />-->
 
 <dl4dh:get-udpipe-analyses/>

 <p:store href="{$main-directory-path}report-udpipe-analyses.xml" message="Storing {$main-directory-path}report-udpipe-analyses.xml"/>
 
 <dl4dh:convert-udpipe-items-to-tei name="convert-udpipe-items-to-tei" />
 
 <p:store href="{$main-directory-path}report-convert-udpipe-items-to-tei.xml" message="Storing {$main-directory-path}report-cenvert-udpipe-items-to-tei.xml"/>
 

<!-- <p:load href="{$main-directory-path}report-convert-udpipe-items-to-tei.xml" message="Loading {$main-directory-path}report-cenvert-udpipe-items-to-tei.xml"/>-->
 
 <dl4dh:merge-tei-items />
 
 <p:store href="{$main-directory-path}report-merge-tei-items.xml" message="Storing {$main-directory-path}report-merge-tei-items.xml"/>
 
 <!-- jeden z vygenerovaných souborů, přebírají se z něj informace typu availability -->
 <p:variable name="file-name" select="/dl4dh:report/dl4dh:result[1]/dl4dh:step[1]/dl4dh:uuids[1]/dl4dh:uuid[1]" />
 
 <p:xslt message="FOXML to TEI" depends="convert-udpipe-items-to-tei convert-alto-items-to-tei" 
  parameters="map{ 'file-name': $file-name }" >
  <p:with-input port="source" pipe="data@get-foxml" />
  <p:with-input port="stylesheet" href="../Xslt/foxml-to-tei.xsl" />
 </p:xslt>
 
 <p:store href="{$main-directory-path}../Foxml/TEI.xml"  message="Storing complete TEI: {$main-directory-path}../Foxml/TEI.xml."/>
 
 <p:sink message="DONE" />
 
</p:declare-step>
