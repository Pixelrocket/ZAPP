#Informatiebeveiliging

<table>
<tbody>
<tr>
  <td>Nr.</td><td>Watje</td><td>Rationale</td><td>Hoetje</td><td>Opmerkingen</td>
</tr><tr>
  <td>1</td><td>
    Van de drie aspecten van informatiebeveiliging (integriteit, beschikbaarheid, vertrouwelijkheid) is het voor ZAPP specifiek van belang om de vertrouwelijkheid te beschermen
  </td><td>
    Integriteit en beschikbaarheid zitten meer aan de centrale ZilliZ-kant, ook omdat ZAPP vooral lezen is en weinig schrijven
  </td><td>
    authenticatie, autorisatie, vercijfering
  </td><td>
  </td>
</tr><tr>
  <td>2</td>
  <td>
    De bescherming van de vertrouwelijkheid moet gerechtigde gebruikers zo min mogelijk in de weg zitten bij hun toegang tot de informatie
  </td><td>
    Het primaire doel van ZAPP als toevoeging op de bestaande Web-toegang is dat je er snel en eenvoudig bij kan
  </td><td>
    Zoveel mogelijk vermijden van tekstinvoer voor authenticatie
  </td><td>
  </td>
</tr><tr>
  <td>3</td>
  <td>
    Beveiligingsmaatregelen moeten transparant en inzichtelijk zijn voor gebruikers
  </td><td>
    Geen 'security by obscurity'; wij tonen aan dat het veilig is door uit te leggen hoe de beveiliging werkt. Dat maakt het beveiligingssysteem ontvankelijk voor verbeteringsvoorstellen van buitenaf. Bovendien draagt het bij aan het vertrouwen van de gebruikers in het beveiligingssysteem. En gebruikers zijn beter in staat om veilig met het systeem om te gaan
  </td><td>
    Het beveiligingssysteem beschrijven in helder lekenproza en die tekst eenvoudig lokaal toegankelijk maken vanuit ZAPP
  </td><td>
    Beschrijven: <br> - Wat moet een gebruiker in het normale geval hebben en doen om ZAPP te kunnen gebruiken? <br> - Wat moet een hacker kunnen en doen om toegang te krijgen op basis van een mobiel apparaat met een geactiveerde ZAPP erop dat hij in handen heeft gekregen? <br> - Wat moet een hacker kunnen en doen om toegang te krijgen als hij de gebruikersnaam en het wachtwoord van een account te weten is gekomen? <br> - Wat kan een hacker als hij een 'token' heeft weten te bemachtigen?
  </td>
</tr><tr>
  <td>4</td>
  <td>
    Gegevensuitwisseling tussen ZAPP en de ZilliZ-server mag voor derden niet inzichtelijk zijn
  </td><td>
    Internetverkeer kan gemakkelijk afgeluisterd worden, maar wat derden zo kunnen onderscheppen, mag voor hen niet leesbaar zijn
  </td><td>
    Vercijfering met HTTPS
  </td><td>
  </td>
</tr><tr>
  <td>5</td>
  <td>
    Waar mogelijk hergebruik beveiliging van bestaande ZilliZ-toegang
  </td><td>
    ZAPP-gebruikers zijn meestal bestaande gebruikers van het ZilliZ-systeem en hebben daar dan al een account met de bijbehorende autorisaties (w.o. koppeling van cliënten aan eencliëntvertegenwoordiger). Het is voor de gebruikers handig om voor ZAPP hetzelfde account te kunnen gebruiken. En het is voor de beveiliging beter om niet meer dan één enkele lijst van accounts en autorisaties te hebben
  </td><td>
    - Huidig systeem van gebruikersnamen en wachtwoorden; <br> - ZAPP-account = ZilliZ-account; <br> - Huidig systeem van toekennen van autorisaties aan accounts
  </td><td>
  </td>
</tr><tr>
  <td>6</td>
  <td>
    Clientvertegenwoordigers mogen alleen informatie inzien over hun 'eigen' cliënten
  </td><td>
    vanzelfsprekend
  </td><td>
    Authenticatie als ZilliZ-gebruiker, autorisatie met koppeling cliënt-cliëntvertegenwoordiger binnen ZilliZ
  </td><td>
  </td>
</tr><tr>
  <td>7</td>
  <td>
    Cliëntinformatie mag niet op het mobiele apparaat worden opgeslagen
  </td><td>
    Een derde die toegang weet te krijgen tot het apparaat, mag daarmee niet de mogelijkheid te krijgen om cliëntinformatie in te zien
  </td><td>
    - Alle door ZAPP van ZilliZ gedownloade gegevens alleen in het werkgeheugen van het apparaat bewaren om in ZAPP te tonen; <br> - Bij het verlaten van ZAPP de gedownloade gegevens in het geheugen wissen; <br> - Bij het weer starten van ZAPP de laatst getoonde gegevens opnieuw ophalen van de ZilliZ-server <br> - Daarom zorgen dat alle gegevensselecties als zodanig specifiek adresseerbaar zijn (met een URL; volgens REST)
  </td><td>
  </td>
</tr><tr>
  <td>8</td>
  <td>
    Wachtwoord van ZilliZ-account mag niet op het mobiele apparaat worden opgeslagen
  </td><td>
    Een derde die toegang weet te krijgen tot het apparaat, mag daarmee niet de mogelijkheid te krijgen om het wachtwoord te achterhalen
  </td><td>
    - Wachtwoord alleen in het werkgeheugen houden tijdens het aanmeldproces; <br> - Aanmeldproces levert een 'token' (toeganssleutel); <br> - Toegang tot informatie in ZilliZ gaat vervolgens op basis van het token
  </td><td>
  </td>
</tr><tr>
  <td>9</td>
  <td>
    ZAPP-toegang vanaf een speciefiek mobiel apparaat moet expliciet door de gebruiker worden goedgekeurd
  </td><td>
    Een derde die de beschikking weet te krijgen over de gebruikersnaam en het wachtwoord van een gebruiker moet daarmee niet zomaar de mogelijkheid hebben om vanaf een willekeurig apparaat daadwerkelijk via ZAPP toegang te krijgen tot cliëntinformatie
  </td><td>
    - Een identificatie van het apparaat meesturen met de verzoeken vanuit ZAPP naar de ZilliZ-server <br> - De gebruiker via zijn e-mailadres om goedkeuring vragen voor toegang met zijn account vanaf het nieuwe apparaat
  </td><td>
    **Vraag:** Hoe doet de HAN dat met die apparaat-identificatie?
  </td>
</tr>

</tbody>
</table>
