# Ausführbare Verifikation (Ebene 1) für code-erzeugende Eval-Szenarien.
# Enthält JDK 21 und die versteckten Referenztests. Das (vom Agenten
# bearbeitete) Ziel-Repo wird zur Laufzeit read-only nach /repo gemountet,
# gegen den Referenztest kompiliert und ausgeführt.
#
# Die Basis ist per Digest gepinnt (reproduzierbar, analog zu d-check). Zum
# Aktualisieren den Tag eclipse-temurin:21-jdk-noble neu auflösen und den
# Digest hier ersetzen.
FROM eclipse-temurin@sha256:81cecb98bcca2d5d5c3d496e71779073865db0d0bd776ecf434e017f20dac638

# Versteckte Referenztests + Verifikations-Skript ins Image backen.
COPY verify/ /opt/eval/verify/
COPY docker-verify.sh /opt/eval/docker-verify.sh
RUN chmod +x /opt/eval/docker-verify.sh

WORKDIR /work
ENTRYPOINT ["/opt/eval/docker-verify.sh"]
