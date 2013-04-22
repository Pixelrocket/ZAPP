#Informatiebeveiliging

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
  Een derde die toegang weet te krijgen tot het apparaat, mag daarmee niet de mogelijkheid te krijgen om het wachtwoord te achterhalen
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

<!--
<tr><td></td><td>
</td><td>
</td><td>
</td><td>
</td></tr>
-->

</tbody></table>
