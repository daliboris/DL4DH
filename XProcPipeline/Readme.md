# XProc Pipeline DL4DH

Sada nástrojů v programovacím jazyce [XProc 3.0](https://xproc.org/specifications.html) a [XSLT](https://www.w3.org/Style/XSL/).

K jejímu spouštění slouží volně dostupná implementace procesoru XProc 3.0 v Javě [MorganaXProc-III](https://www.xml-project.com/morganaxproc-iii/) a bezplatná knihovna [Saxon 10 HE](http://saxon.sourceforge.net/#F10HE) pro transformace XSLT a XQuery.

## Podpora

Nástroje vznikly v rámci projektu DL4DH – VÝVOJ NÁSTROJŮ PRO EFEKTIVNĚJŠÍ VYUŽITÍ A VYTĚŽOVÁNÍ DAT Z DIGITÁLNÍCH KNIHOVEN K POSÍLENÍ VÝZKUMU DIGITAL HUMANITIES a byl podpořen projektem Ministerstva kultury ČR č. [DG20P02OVV002](https://www.isvavai.cz/cep?s=jednoduche-vyhledavani&ss=detail&n=0&h=DG20P02OVV002).

## Licence

<p xmlns:cc="http://creativecommons.org/ns#" xmlns:dct="http://purl.org/dc/terms/"><a property="dct:title" rel="cc:attributionURL" href="https://github.com/daliboris/DL4DH/XProcPipeline">XProc Pipeline DL4DH</a> by <a rel="cc:attributionURL dct:creator" property="cc:attributionName" href="https://github.com/daliboris">Boris Lehečka</a> is licensed under <a href="http://creativecommons.org/licenses/by/4.0/?ref=chooser-v1" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">CC BY 4.0<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"></a></p>

## Aplikace zatím umí: 

- stáhnout pomocí API Krameria dokument FOXML, 
- stáhnout pomocí API Krameria jednotlivé strany publikace ve formátu JPEG,
- stáhnout pomocí API Krameria jednotlivé strany publikace ve formátu ALTO,
- převést ALTO na TEI (s vyznačením textových úseků a odpovídajících zón na obrázku),
- převést předchozí TEI na prostý texty (kvůli volání služeb NameTag a UDPipe),
- volání API služby NameTag a konverze interního XML do TEI,
- volání API služby UDPipe a konverze formátu CoNLL-U do TEI,
- sloučení údajů z předchozích dvou kroků do jednoho dokumentu (vše zatím probíhalo na úrovní jedné strany),
- sestavení kompletního dokumentu TEI na základě údajů z FOXML (`<teiHeader>`) a údajů v TEI pro jednotlivé strany (`<text>`, resp. `<body>`).

## Aplikace zatím neumí:

- propojit výsledné TEI (obohacené službami NameTag a UDPipe) se zónami a faksimilemi, které vznikly na základě formátu ALTO,
- označit vhodněji čísla stran (zatím se používá hodnota UUID).
- pracovat s ilustracemi, tabulkami a dalšími netextovými objekty,
- zpracovat externími nástroji rozsáhlejší strany (nefunguje volání REST API služeb metodou POST).

## Základní nastavení

Nastavení se (zatím) provádí v souboru **DL4DH.xpl** v rámci elementu `<p:input port="source">`.

```xml
<request debug="true"
  main-directory-path="file:/D:/Temp/DL4DH/XProc/Xml/"> <!-- TODO: nastavit @main-directory-path na složku, do níž se ukládají (mezi)výsledky  -->
  <service name="Kramerius">
   <item name="base-url" value="https://dnnt.mzk.cz/search/api/v5.0/item/" />
   <!-- Washingtonská deklarace -->
   <item name="uuid" value="3c4c3540-3130-11ea-b0e3-005056827e52" />
   <!-- TODO: nastavit @value UUID dokumentu, který se má zpracovat -->
  <item name="foxml-directory-path" value="Foxml/" />
  <item name="alto-directory-path" value="Alto/" />
  <item name="image-directory-path" value="Images/" />  
  </service>
  ...
</request>  
```