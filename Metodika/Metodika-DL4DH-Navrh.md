# Metodika DL4DH

Návrh osnovy metodiky.

## Podklady

### RIV

[Definice druhů výsledků ve formátu .docx](https://www.isvavai.cz/dokumenty/definice_druhu_vysledku.docx)

> Výsledek „Metodika“ je souhrnem doporučených praktik a postupů schválených, certifikovaných nebo akreditovaných kompetenčně příslušným orgánem veřejné správy … a s jednoznačně vymezenými uživateli tak, aby tito uživatelé měli jistotu, že při jejím dodržení budou získané výsledky průkazné, opakovatelné a že se jich lze dovolat.
>
> Výsledek „Metodika“ realizoval původní výsledky výzkumu a vývoje, které byly uskutečněny autorem nebo týmem, jehož byl autor členem.
>
> … musí být takové schválení/certifikace/akreditace uděleno na základě vypracování dvou nezávislých oponentních posudků …

### Příklady metodik

Metodiky od roku 2016, oblast humanitních věd, poskytovatel MK, vyhledáno v [RIVu](https://www.isvavai.cz/riv)

- [Metodika logické ochrany digitálních dat](http://invenio.nusl.cz/record/371612?ln=cs)
- [Metodika uchování a prezentace multimediálních dat](http://invenio.nusl.cz/record/432001?ln=cs)
- [Metodika evidence dokladů hmotné kultury v narativních pramenech se zaměřením na zpřístupnění kulturně historických informací v cizojazyčných pramenech](https://www.isvavai.cz/riv?s=rozsirene-vyhledavani&ss=detail&n=0&h=RIV%2F67985963%3A_____%2F21%3A00540930%21RIV21-MK0-67985963)
- [Certifikovaná metodika s názvem Století informace: svět informatiky a elektrotechniky – počítačový svět v nás](https://www.isvavai.cz/riv?s=jednoduche-vyhledavani&ss=detail&n=0&h=RIV%2F68407700%3A21230%2F19%3A00336397%21RIV20-MK0-21230___), [NÚŠL](http://invenio.nusl.cz/record/408923)
- [Certifikovaná metodika digitalizace všech typů obrazových zdrojů filmových materiálů](http://invenio.nusl.cz/record/369582/files/nusl-369582_1.pdf)
- [Interpretace fotografie z hlediska obsažených obrazových informací. Metodika maximalizace reálného využití informací poskytovaných historickým fotografickým materiálem jako solitérní památkou a v kontextu používaných databázových systémů evidence pro prohloubení určení a poznání zobrazeného v každodenní praxi při identifikaci osob, míst, ateliérů apod.](https://www.npu.cz/publikace/Interpretace%20fotografie%20z%20hlediska%20obsazenych%20obrazovych%20informaci.pdf)

## Úvahy o metodice DL4DH

Ideální čtenář/uživatel metodiky

- \(A) provozovatel digitální knihovny Kramerius
- \(B) badatel v oblasti digitálních humanitních věd
  - \(B1) programátor
  - \(B2) „neprogramátor“

Co by se čtenáři/uživatelé měli dozvědět

- \(A) provozovatel digitální knihovny Kramerius
  - co je součástí dat v Krameriu
  - co je součástí dat v Krameriu+
  - Kramerius+
    - nasazení (požadavky na HW a SW),
    - konfigurace (interní a externí služby)
    - provoz (aktualizace SW, synchronizace dat)
- \(B) badatel v oblasti digitálních humanitních věd
  - jaká data jsou k dispozici (v Krameriu)
    - objem digitalizátů
    - struktura (monografie, periodika, virtuální sbírky…)
    - ne/dostupnost dat chráněných autorským zákonem
  - jaké údaje o datech jsou k dispozici
    - metadata (k dokumentu, k obrázkům)
    - obrazová data
    - textová data
  - v jakém formátu jsou údaje o datech k dispozici
    - CSV/TSV
    - JSON
    - TEI
    - ALTO
  - schémata poskytovaných dat
    - XSD, RNG pro ALTO a TEI
    - JSON Schema
  - jak jsou údaje o datech zachyceny v jednotlivých formátech
  - jak pracovat s DL4DH Feederem správně, aby uživatel dospěl ke správným výsledkům
  - práce s uživatelských rozhraním Krameria+/DL4DH Feederu
  - API pro práci s Krameriem+ a DL4DH Feederem
  - práce s Krameriem (přepnutí na Kramerius+)
  - příklady výzkumných témat
    - podrobná studie i s výsledky
    - náměty na další studie s předpokládaným scénářem prací

 Další užitečné informace

- nové metody v humanitních vědách
  - DH
  - velké objemy dat
- formáty poskytovaných dat
  - syntaktická pravidla jednotlivých formátů
  - výhody a nevýhody formátů
  - standardizační autority (ALTO, TEI)
- právní rámec
  - autorský zákon
  - směrnice EU (data pro výzkum)
- obohacování textových dat
  - jaké nástroje jsou k dispozici
  - které nástroje se dostaly do DL4DH a proč
- architektura zvoleného řešení
  - technologie
  - komponenty systému
    - komunikace mezi nimi
  - zdůvodnění zvolených řešení
- slabá místa DL4DH
  - k čemu se nedá použít
- informace o jiných podobných projektech
