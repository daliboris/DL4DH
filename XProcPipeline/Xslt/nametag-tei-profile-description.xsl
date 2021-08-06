<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:tei="http://www.tei-c.org/ns/1.0"
 xmlns="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs math xd tei" version="3.0">
 <xd:doc scope="stylesheet">
  <xd:desc>
   <xd:p><xd:b>Created on:</xd:b> Jul 10, 2021</xd:p>
   <xd:p><xd:b>Author:</xd:b> Boris</xd:p>
   <xd:p/>
  </xd:desc>
 </xd:doc>


 <xsl:template name="nametag-classCode">
  <classCode scheme="https://ufal.mff.cuni.cz/nametag/2/models" xmlns="http://www.tei-c.org/ns/1.0">
   <interpGrp>
    <interp xml:id="nametag-P">Komplexní jméno osoby</interp>
    <interp xml:id="nametag-T">Komplexní časový údaj</interp>
    <interp xml:id="nametag-A">Komplexní adresa</interp>
    <interp xml:id="nametag-C">Komplexní bibliografická položka</interp>
    <interp xml:id="nametag-a">ČÍSLA JAKO SOUČÁSTI ADRES</interp>
    <interp xml:id="nametag-ah">číslo popisné</interp>
    <interp xml:id="nametag-at">telefon, fax</interp>
    <interp xml:id="nametag-az">PSČ</interp>
    <interp xml:id="nametag-g">GEOGRAFICKÉ NÁZVY</interp>
    <interp xml:id="nametag-gc">státní útvary</interp>
    <interp xml:id="nametag-gh">vodní útvary</interp>
    <interp xml:id="nametag-gl">přírodní oblasti / útvary</interp>
    <interp xml:id="nametag-gq">části obcí, pomístní názvy</interp>
    <interp xml:id="nametag-gr">menší územní jednotky</interp>
    <interp xml:id="nametag-gs">ulice, náměstí</interp>
    <interp xml:id="nametag-gt">kontinenty</interp>
    <interp xml:id="nametag-gu">obce, hrady a zámky</interp>
    <interp xml:id="nametag-g_">geografický název nespecifikovaného typu / nezařaditelný do ostatních typů</interp>
    <interp xml:id="nametag-i">NÁZVY INSTITUCÍ</interp>
    <interp xml:id="nametag-ia">přednášky, konference, soutěže,...</interp>
    <interp xml:id="nametag-ic">kulturní, vzdělávací a vědecké instituce, sportovní kluby,...</interp>
    <interp xml:id="nametag-if">firmy, koncerny, hotely,...</interp>
    <interp xml:id="nametag-io">státní a mezinárodní instituce, politické strany a hnutí, náboženské skupiny</interp>
    <interp xml:id="nametag-i_">instituce nespecifikovaného typu / nezařaditelné do ostatních typů</interp>
    <interp xml:id="nametag-m">NÁZVY MÉDIÍ</interp>
    <interp xml:id="nametag-me">e-mailové adresy</interp>
    <interp xml:id="nametag-mi">internetové odkazy</interp>
    <interp xml:id="nametag-mn">periodika, redakce, tiskové agentury</interp>
    <interp xml:id="nametag-ms">rozhlasové a televizní stanice</interp>
    <interp xml:id="nametag-n">ČÍSLA SE SPECIFICKÝM VÝZNAMEM</interp>
    <interp xml:id="nametag-na">věk</interp>
    <interp xml:id="nametag-nc">číslo s významem počtu</interp>
    <interp xml:id="nametag-nb">číslo strany, kapitoly, oddílu, obrázku</interp>
    <interp xml:id="nametag-no">číslo s významem pořadí</interp>
    <interp xml:id="nametag-ns">sportovní skóre</interp>
    <interp xml:id="nametag-ni">itemizátor</interp>
    <interp xml:id="nametag-n_">číslo se specifickým významem, jehož typ nebyl vyčleněn jako samostatný / nelze identifikovat</interp>
    <interp xml:id="nametag-o">NÁZVY VĚCÍ</interp>
    <interp xml:id="nametag-oa">kulturní artefakty (knihy, filmy stavby,...)</interp>
    <interp xml:id="nametag-oe">měrné jednotky (zapsané zkratkou)</interp>
    <interp xml:id="nametag-om">měny (zapsané zkratkou, symbolem)</interp>
    <interp xml:id="nametag-op">výrobky</interp>
    <interp xml:id="nametag-or">předpisy, normy,..., jejich sbírky</interp>
    <interp xml:id="nametag-o_">názvy nespecifikovaného typu / nezařaditelné do ostatních typů</interp>
    <interp xml:id="nametag-p">JMÉNA OSOB</interp>
    <interp xml:id="nametag-pc">obyvatelská jména</interp>
    <interp xml:id="nametag-pd">titul (pouze zkratkou)</interp>
    <interp xml:id="nametag-pf">křestní jméno</interp>
    <interp xml:id="nametag-pm">druhé křestní jméno</interp>
    <interp xml:id="nametag-pp">náboženské postavy, pohádkové a mytické postavy, personifikované vlastnosti</interp>
    <interp xml:id="nametag-ps">příjmení</interp>
    <interp xml:id="nametag-p_">jméno osoby nespecifikovaného typu / nezařaditelné do ostatních typů</interp>
    <interp xml:id="nametag-t">ČASOVÉ ÚDAJE</interp>
    <interp xml:id="nametag-td">den</interp>
    <interp xml:id="nametag-tf">svátky a významné dny</interp>
    <interp xml:id="nametag-th">hodina</interp>
    <interp xml:id="nametag-tm">měsíc</interp>
    <interp xml:id="nametag-ty">rok</interp>
   </interpGrp>
  </classCode>
 </xsl:template>

</xsl:stylesheet>
