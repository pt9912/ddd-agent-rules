# Schlechtes Beispiel: Infrastruktur in der Domäne

```java
@Entity
public class Bestellung {
    public void bestaetigen(KafkaTemplate<String, Object> kafka) {
        // fachliche Regel
        kafka.send("bestellungen", this);
    }
}
```

Probleme:

- Domänenverhalten hängt von ORM- und Messaging-Infrastruktur ab
- Tests benötigen technische Abhängigkeiten
- interner Domänenzustand dringt in einen Integrationsvertrag ein

## Maßgebliche Regeln

- [DDD-EVT-001](../../rules/11-domain-events.md)
- [DDD-INF-001](../../rules/13-infrastructure-layer.md)
- [DDD-INT-001](../../rules/14-context-integration.md)
