mkdir secrets
docker run oryd/oathkeeper:latest credentials generate --alg RS256 > secrets/jwks.json
