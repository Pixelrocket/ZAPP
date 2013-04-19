#Informatiebeveiliging

Nr. | Watje | Rationale | Hoetje | Opmerkingen
--- | ----- | --------- | ------ | ----------
1 | Van de drie aspecten van informatiebeveiliging (integriteit, beschikbaarheid, vertrouwelijkheid) is het voor ZAPP specifiek van belang om de vertrouwelijkheid te beschermen | Integriteit en beschikbaarheid zitten meer aan de centrale ZilliZ-kant, ook omdat ZAPP vooral lezen is en weinig schrijven | authenticatie, autorisatie, vercijfering
2 | De bescherming van de vertrouwelijkheid moet gerechtigde gebruikers zo min mogelijk in de weg zitten bij hun toegang tot de informatie | Het primaire doel van ZAPP als toevoeging op de bestaande Web-toegang is dat je er snel en eenvoudig bij kan | Zoveel mogelijk vermijden van tekstinvoer voor authenticatie
3 | Gegevensuitwisseling tussen ZAPP en de ZilliZ-server mag voor derden niet inzichtelijk zijn | Internetverkeer kan gemakkelijk afgeluisterd worden, maar wat derden zo kunnen onderscheppen, mag voor hen niet leesbaar zijn | Vercijfering met HTTPS
4 | Clientvertegenwoordigers mogen alleen informatie inzien over hun 'eigen' cliënten | vanzelfsprekend | Authenticatie als ZilliZ-gebruiker, autorisatie met koppeling cliënt-cliëntvertegenwoordiger binnen ZilliZ
5 | TODO