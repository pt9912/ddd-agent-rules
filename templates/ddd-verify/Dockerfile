# Reproduzierbare Verifikation der DDD-Invarianten eines Ziel-Repos.
# Kompiliert die Java-Quellen des Repos zusammen mit den Invariantentests unter
# ddd-invariants/ und führt sie aus — unabhängig vom lokalen JDK, ohne Netzwerk.
#
# Basis per Digest gepinnt (reproduzierbar). Zum Aktualisieren den Tag
# eclipse-temurin:21-jdk-noble neu auflösen und den Digest hier ersetzen.
FROM eclipse-temurin@sha256:81cecb98bcca2d5d5c3d496e71779073865db0d0bd776ecf434e017f20dac638

COPY verify.sh /opt/ddd/verify.sh
RUN chmod +x /opt/ddd/verify.sh

WORKDIR /work
ENTRYPOINT ["/opt/ddd/verify.sh"]
