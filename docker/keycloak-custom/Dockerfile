FROM quay.io/keycloak/keycloak:26.0.6

COPY ./keycloak/themes/oralie/theme /opt/keycloak/themes
COPY ./keycloak/realm-export.json /opt/keycloak/data/import/realm-export.json

# ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start-dev", "--import-realm"]
