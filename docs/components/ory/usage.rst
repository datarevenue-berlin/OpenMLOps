Usage
=========================

ORY Oathkeeper
--------------

Access Rules
~~~~~~~~~~~~~~~~~~~~

In order to configure access for an specific service, we need to specify Access Rules.
All the Access Rules are defined in the file `access-rule-oathkeeper.yaml`
(for convenience and maintainability)

** Allow all access **

```yaml
- id: oathkeeper-access-rule
  match:
    url: <{http,https}>://${hostname}/allowed-service/<**>
    methods:
      - GET
  authenticators:
    - handler: anonymous
  authorizer:
    handler: allow
  mutators:
    - handler: noop
  credentials_issuer:
    handler: noop
```

This configuration will register all the incoming requests as a `guest` user, thus, not
performing any credentials validation.

** Authenticate User **

```yaml
- id: protected-service
  match:
    url: <{http,https}>://${hostname}/authenticated-service/<**>
    methods:
      - GET
  authenticators:
    - handler: cookie_session
  authorizer:
    handler: allow
  mutators:
    - handler: id_token
  errors:
    - handler: redirect
      config:
        to: http://${hostname}/auth/login

This configuration will require all requests to be authenticated by using a session cookie.
Note that the Oathkeeper doesn't care about the authentication method that was used by
ORY Kratos, as long as it provides a valid Session Cookie.

