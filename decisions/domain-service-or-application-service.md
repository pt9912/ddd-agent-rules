# Domänendienst oder Anwendungsdienst?

Verwende einen Domänendienst, wenn:

- die Operation ein fachliches Konzept ist
- keine Entität und kein Wertobjekt sie auf natürliche Weise besitzt
- sie zustandslos bleiben kann
- sie nicht von Transport oder Persistenz abhängt

Verwende einen Anwendungsdienst, wenn:

- ein Anwendungsfall koordiniert wird
- Aggregate geladen und gespeichert werden
- eine Transaktion eröffnet wird
- ein Aufrufer authentifiziert und eine grobe Zugriffskontrolle auf den Anwendungsfall durchgesetzt wird
- externe Systeme über Ports aufgerufen werden
- Domänenoperationen in eine Reihenfolge gebracht werden

Ein Dienst, der fachliche Regeln enthält und zugleich die Datenbank kennt, ist üblicherweise falsch platziert.
Wenn eine Berechtigung vom Aggregatzustand oder einer anderen fachlichen Richtlinie abhängt, übergib die relevanten Akteurs- oder Berechtigungsinformationen an die Domäne und setze die Regel dort durch.

## Maßgebliche Regeln

- [DDD-SVC-001](../rules/09-domain-services.md)
- [DDD-APP-001](../rules/12-application-layer.md)
