#Informatiebeveiliging

##Eisen

<table><thead><tr>
<th>Nr.</th><th>Watje</th><th>Rationale</th><th>Hoetje</th><th>Opmerkingen</th>
</tr></thead><tbody>

<tr><td>1</td><td>
  Van de drie aspecten van informatiebeveiliging (integriteit, beschikbaarheid, vertrouwelijkheid) is het voor ZAPP specifiek van belang om de vertrouwelijkheid te beschermen
</td><td>
  Integriteit en beschikbaarheid zitten meer aan de centrale ZilliZ-kant, ook omdat ZAPP vooral lezen is en weinig schrijven
</td><td>
  authenticatie, autorisatie, vercijfering
</td><td>
</td></tr>

<tr><td>2</td><td>
  De bescherming van de vertrouwelijkheid moet gerechtigde gebruikers zo min mogelijk in de weg zitten bij hun toegang tot de informatie
</td><td>
  Het primaire doel van ZAPP als toevoeging op de bestaande Web-toegang is dat je er snel en eenvoudig bij kan
</td><td>
  Zoveel mogelijk vermijden van tekstinvoer voor authenticatie
</td><td>
</td></tr>

<tr><td>3</td><td>
  Beveiligingsmaatregelen moeten transparant en inzichtelijk zijn voor gebruikers
</td><td>
  Geen 'security by obscurity'; wij tonen aan dat het veilig is door uit te leggen hoe de beveiliging werkt. Dat maakt het beveiligingssysteem ontvankelijk voor verbeteringsvoorstellen van buitenaf. Bovendien draagt het bij aan het vertrouwen van de gebruikers in het beveiligingssysteem. En gebruikers zijn beter in staat om veilig met het systeem om te gaan
</td><td>
  Het beveiligingssysteem beschrijven in helder lekenproza en die tekst eenvoudig lokaal toegankelijk maken vanuit ZAPP
</td><td>
  Beschrijven:
  <ul><li>Wat moet een gebruiker in het normale geval hebben en doen om ZAPP te kunnen gebruiken?
  </li><li>Wat moet een hacker kunnen en doen om toegang te krijgen op basis van een mobiel apparaat met een geactiveerde ZAPP erop dat hij in handen heeft gekregen?
  </li><li>Wat moet een hacker kunnen en doen om toegang te krijgen als hij de gebruikersnaam en het wachtwoord van een account te weten is gekomen?
  </li><li>Wat kan een hacker als hij een 'token' heeft weten te onderscheppen?
  </li></ul>
</td></tr>

<tr><td>4</td><td>
  Gegevensuitwisseling tussen ZAPP en de ZilliZ-server mag voor derden niet inzichtelijk zijn
</td><td>
  Internetverkeer kan gemakkelijk afgeluisterd worden, maar wat derden zo kunnen onderscheppen, mag voor hen niet leesbaar zijn
</td><td>
  Vercijfering met HTTPS
</td><td>
</td></tr>

<tr><td>5</td><td>
  Waar mogelijk hergebruik beveiliging van bestaande ZilliZ-toegang
</td><td>
  ZAPP-gebruikers zijn meestal bestaande gebruikers van het ZilliZ-systeem en hebben daar dan al een account met de bijbehorende autorisaties (w.o. koppeling van cliënten aan eencliëntvertegenwoordiger). Het is voor de gebruikers handig om voor ZAPP hetzelfde account te kunnen gebruiken. En het is voor de beveiliging beter om niet meer dan één enkele lijst van accounts en autorisaties te hebben
</td><td>
  <ul><li>Huidig systeem van gebruikersnamen en wachtwoorden
  </li><li>ZAPP-account = ZilliZ-account
  </li><li>Huidig systeem van toekennen van autorisaties aan accounts
  </li></ul>
</td><td>
</td></tr>

<tr><td>6</td><td>
  Clientvertegenwoordigers mogen alleen informatie inzien over hun 'eigen' cliënten
</td><td>
  vanzelfsprekend
</td><td>
  Authenticatie als ZilliZ-gebruiker, autorisatie met koppeling cliënt-cliëntvertegenwoordiger binnen ZilliZ
</td><td>
</td></tr>

<tr><td>7</td><td>
  Cliëntinformatie mag niet op het mobiele apparaat worden opgeslagen
</td><td>
  Een derde die toegang weet te krijgen tot het apparaat, mag daarmee niet de mogelijkheid te krijgen om cliëntinformatie in te zien
</td><td>
  <ul><li>Alle door ZAPP van ZilliZ gedownloade gegevens alleen in het werkgeheugen van het apparaat bewaren om in ZAPP te tonen
  </li><li>Bij het verlaten van ZAPP de gedownloade gegevens in het geheugen wissen
  </li><li>Bij het weer starten van ZAPP de laatst getoonde gegevens opnieuw ophalen van de ZilliZ-server
  </li><li>Daarom zorgen dat alle gegevensselecties als zodanig specifiek adresseerbaar zijn (met een URL; volgens REST)
  </li></ul>
</td><td>
</td></tr>

<tr><td>8</td><td>
  Wachtwoord van ZilliZ-account mag niet op het mobiele apparaat worden opgeslagen
</td><td>
  Een derde die toegang weet te krijgen tot het apparaat, mag daarmee niet de mogelijkheid krijgen om het wachtwoord te achterhalen
</td><td>
  <ul><li>Wachtwoord alleen in het werkgeheugen houden tijdens het aanmeldproces
  </li><li>Aanmeldproces levert een 'token' (toeganssleutel)
  </li><li>Toegang tot informatie in ZilliZ gaat vervolgens op basis van het token
  </li></ul>
</td><td>
</td></tr>

<tr><td>9</td><td>
  ZAPP-toegang vanaf een speciefiek mobiel apparaat moet expliciet door de gebruiker worden goedgekeurd
</td><td>
  Een derde die de beschikking weet te krijgen over de gebruikersnaam en het wachtwoord van een gebruiker moet daarmee niet zomaar de mogelijkheid hebben om vanaf een willekeurig apparaat daadwerkelijk via ZAPP toegang te krijgen tot cliëntinformatie
</td><td>
  <ul><li>Een identificatie van het apparaat meesturen met de verzoeken vanuit ZAPP naar de ZilliZ-server
  </li><li>De gebruiker via zijn e-mailadres om goedkeuring vragen voor toegang met zijn account vanaf het nieuwe apparaat
  </li></ul>
</td><td>
  <b>Vraag:</b> Hoe doet de HAN dat met die apparaat-identificatie?
</td></tr>

<tr><td>10</td><td>
  Uitgegeven toegangssleutels moeten ingetrokken kunnen worden
</td><td>
  Bij verlies of diefstal van een apparaat met ZAPP erop, mogen de daarop aanwezige toegangssleutels ('tokens') niet langer toegang kunnen geven tot cliëntinformatie op de ZilliZ-server
</td><td>
  Beheerders of gebruikers zelf krijgen via de ZilliZ-website de mogelijkheid om alle voor hun account actieve tokens te deactiveren
</td><td>
  <b>Vraag:</b> Alleen beheerders of ook gebruikers? <br> <b>Vraag:</b> Alle actieve tokens, of per specifiek apparaat?
</td></tr>

<tr><td>11</td><td>
  Toegang tot ZAPP op het mobiele apparaat moet worden afgeschermd
</td><td>
  Een derde die toegang weet te krijgen tot het apparaat, mag daarmee niet meteen ook de mogelijkheid hebben om ZAPP erop te openen en zo met een nog actieve toegangssleutel de cliëntinformatie in te zien
</td><td>
  Iedere keer bij het starten van ZAPP moet de gebruiker een PIN-code ingeven en de gebruiker moet de PIN-code geheim houden
</td><td>
</td></tr>

<tr><td>12</td><td>
  Gebruikers moeten hun wachtwoord kunnen wijzigen
</td><td>
  Als een gebruiker een wachtwoord heeft gebruikt dat hij ook in andere applicaties heeft gebruikt en bij één van die applicaties is er een beveiligingsincident geweest, dan moet de gebruiker z'n ZilliZ-wachtwoord veranderen, omdat het oude wachtwoord mogelijk bij derden bekend is geworden
</td><td>
  Via de gebruikersinstellingen-pagina van de ZilliZ-website
</td><td>
  <b>Vraag:</b> Zit dit al in de website? <br> <b>Vraag:</b> Zijn er ook al constraints van kracht voor wachtwoordsterkte en geldigheidsduur? <br> <b>Opmerking:</b> Hoewel mogelijk is het niet nodig om dan meteen ook alle tokens van de gebruiker te deactiveren
</td></tr>

<tr><td>13</td><td>
  Gebruikers moeten hun PIN-code kunnen wijzigen
</td><td>
  Als een gebruiker denkt dat z'n PIN-code bij iemand anders bekend is geraakt, dan moet hij een andere PIN-code instellen
</td><td>
  Via de settings binnen ZAPP op het mobiele apparaat
</td><td>
</td></tr>

<!--
<tr><td></td><td>
</td><td>
</td><td>
</td><td>
</td></tr>
-->

</tbody></table>


##Uitleg

Hieronder de in eis nummer 3 bedoelde lekenproza

###ZAPP in gebruik nemen

Om ZAPP te kunnen gaan gebruiken, heb je het volgende nodig:

- Een tablet of smartphone
- Een account voor de bij het apparaat behorende App Store
- Een account (gebruikersnaam en wachtwoord) van ZilliZ, waarvoor de zgn. "extranet" toegang is aangezet
- Een e-mail account, dat is gekoppeld aan je ZilliZ-account

Ga vervolgens als volgt te werk:

1. Download ZAPP uit de App Store
2. Open ZAPP en geef een zelf te kiezen PIN-code op. Onthoud je PIN-code, maar houd 'm geheim
3. Typ de gebruikersnaam en het wachtwoord in van je ZilliZ-account
4. Ga naar je e-mailprogramma en volg de activatielink in de e-mail die je van ZilliZ krijgt. Na de bevestiging van de activatiepagina is ZAPP klaar voor gebruik vanaf jouw apparaat met jouw account
5. Open ZAPP en geef je PIN-code in

Om je wachtwoord te veranderen ga je naar de [gebruikersinstellingen](TODO) op de ZilliZ-website. Om je PIN-code te veranderen, ga je in ZAPP naar de Instellingen. Het is verstandig om een lang en moeilijk te raden wachtwoord te kiezen, dat je niet ook voor andere applicaties gebruikt, en om het regelmatig te veranderen. Je PIN-code kan je in principe onveranderd laten. Maar voor zowel je wachtwoord als je PIN-code geldt: verander 'm zodra je vermoed dat iemand anders 'm te weten gekomen kan zijn.

Als je het apparaat kwijtraakt waar ZAPP op staat, of het wordt gestolen, geef dit dan snel door aan ZilliZ, zodat we de toegang vanaf dat apparaat kunnen blokkeren. Als je het apparaat later weer terugvindt, kan je zelf eenvoudig met je ZilliZ-account en je e-mail de toegang weer instellen.

###Hoe is de cliëntinformatie in ZAPP beveiligd?

Alle cliëntinformatie die in ZAPP wordt getoond, haalt ZAPP van de ZilliZ-server via het Internet. Omdat internetverkeer in principe openbaar is en dus voor iedereeen in te zien, vercijferen we alles met [HTTPS](http://nl.wikipedia.org/wiki/HyperText_Transfer_Protocol_Secure). Alleen jouw ZAPP op jouw apparaat kan de gegevens ontcijferen. Cliëntinformatie wordt nooit op je apparaat opgeslagen; zodra je ZAPP verlaat is alle informatie vergeten en de volgende keer wordt alles opnieuw opgehaald bij de ZilliZ-server. Zo voorkomen we dat iemand die jou apparaat te pakken krijgt erin kan gaan grasduinen naar vertrouwelijke gegevens.

Ook je ZilliZ wachtwoord wordt niet opgeslagen. Als je je gebruikersnaam en wachtwoord opgeeft, krijg jouw ZAPP daarmee van de ZilliZ-server een toegangssleutel (een 'token'), die in alle volgende communicatie steeds de deuren opent. Zodra het token binnen is, wist ZAPP je wachtwoord uit het geheugen van je apparaat. Ook weer om te voorkomen dat iemand anders op jouw apparaat je wachtwoord zou kunnen vinden. Het token kunnen we op afstand deactiveren als het nodig is.

Mocht iemand je gebruikersnaam en wachtwoord weten te achterhalen, dan kan die niet zomaar ZAPP downloaden en inloggen. Zou hij dat proberen, dan krijg jij een mailtje met de vraag of je de ZAPP-toegang met jouw account vanaf een niet eerder gebruikt apparaat wil activeren. Dat is voor jou het signaal dat je je wachtwoord moet veranderen.

Mocht iemand anders jouw apparaat in handen krijgen met ZAPP erop, en hij weet door de schermvergrendeling van het apparaat te breken, dan kan hij ZAPP niet gebruiken, omdat hij jouw PIN-code niet weet. Bovendien kan hij buiten ZAPP om geen vertrouwelijke gegevens op het apparaat vinden, omdat cliëntinformatie en wachtwoorden nooit op het apparaat worden opgeslagen. De toegangssleutel tot de ZilliZ-server, het 'token', is alleen vercijferd op het apparaat aanwezig. Om het te kunnen ontcijferen is de PIN-code nodig, die ook al niet op het apparaat is opgeslagen; die moet telkens door de gebruiker worden ingetypt. Mocht een onvoorstelbaar capabele hacker er toch in slagen om het token te pakken te krijgen, dan hebben we ondertussen tijd genoeg gehad om het token onbruikbaar te maken door het op afstand te deactiveren.


##Technische beschrijving van de beveiliging

De hoetjes onder de streep. TODO