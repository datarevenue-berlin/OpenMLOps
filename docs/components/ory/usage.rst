Usage
=========================

ORY Oathkeeper
--------------

Access Rules
~~~~~~~~~~~~~~~~~~~~

In order to configure access for an specific service, we need to specify Access Rules.
All the Access Rules are defined in the file `access-rule-oathkeeper.yaml`
(for convenience and maintainability)

**Allow all access**::

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

This configuration will register all the incoming requests as a `guest` user, thus, not
performing any credentials validation.

**Authenticate User**::

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

Identities and Providers
~~~~~~~~~~~~~~~~~~~~~~~~

Kratos allows setting up different Identities in which each one can have multiple authentication providers.

An identity ("user", "user account", "account", "subject") is the "who" of a software system.
It can be a customer, employee, user, contractor, or even a programmatic identity such
as an IoT device, application, or some other type of "robot."

This project comes configured with only one Identity called Person. The configuration file
for the Person Indentity can be found under `modules/ory/kratos/schemas/identity.traits.schema.json`.

Each Identity is expected to have one field as an identifier. This can be an user login, e-mail or random number.
Since most of the OIDC providers allow access to the user's e-mail, this is chosen as the unique identifier.

Kratos comes bundled with two authentication mechanisms: password and oidc.
The mechanisms are configured under `modules/ory/kratos/values.yaml`, on the section `kratos.config.selfservice.methods`.
There, it can be configured to whether accept password method and / or OIDC providers.

By default, Github, Google and Microsoft providers are already configured, the administrator only needs
to provide the expected credentials (client id, client secret and tenant id for Microsot)
To set these values, please use the terraform credentials `oauth2_providers`
(see usage in modules/ory/kratos/values.yaml)

Browser Authentication
~~~~~~~~~~~~~~~~~~~~~~

Kratos comes bundled with an UI that allows browser users to follow an authentication flow.
The Login Page should be displayed to the user whenever they try to access a secured service.

The available URLS are:
- https://{host}/profile/auth/registration
- https://{host}/profile/auth/login
- https://{host}/profile/auth/logout

The UI automatically gives the user the authentication methods configured above.

Programatic Access
~~~~~~~~~~~~~~~~~~

Kratos also has an option to authenticate from API Clients.

To initialize the API flow, the client calls the API-flow initialization endpoint
(REST API Reference) which returns a JSON response::

    $ curl -s -X GET \
      -H "Accept: application/json"  \
      https://{host}/.ory/kratos/public/self-service/registration/api |
      jq -r '.methods.password.config.action'\

    {
      "id": "daf9913c-9807-453b-aa01-4a740a43ca4e",
      "type": "api",
      "expires_at": "2020-09-05T08:16:52.043498Z",
      "issued_at": "2020-09-05T08:06:52.043498Z",
      "request_url": "http://127.0.0.1:4433/self-service/registration/api"
      "methods": {
        // password,
        // oidc,
        // ...
      }
    }

Then, the client should send a POST request to the desired actionURL::

    curl -s -X POST -H  "Accept: application/json" -H "Content-Type: application/json" \
      -d '{"traits.email": "registration-session-api@user.org", "password": "fhAzi860a"}' \
      "{actionUrl}" | jq


One example::

    # REGISTER
    $ actionUrl=$(curl -s -X GET -H "Accept: application/json" "https://{host}/.ory/kratos/public/self-service/registration/api" \
    | jq -r ".ui.action")

    $ curl -s -X POST -H  "Accept: application/json" -H "Content-Type: application/json" \
      -d '{"traits.email": "api@user.org", "password": "fhAzi860a", "method": "password"}' \
      "$actionUrl" | jq

    # LOGIN
    # Inits a Login Flow
    $ actionUrl=$(\
      curl -s -X GET -H "Accept: application/json" \
        "https://{host}/.ory/kratos/public/self-service/login/api" \
        | jq -r '.ui.action'\
    )

    # Complete Login Flow with password method
    $ curl -s -X POST -H  "Accept: application/json" -H "Content-Type: application/json" \
        -d '{"password_identifier": "api@user.org", "password": "fhAzi860a", "method": "password"}' \
        "$actionUrl" | jq

    # It will return a Session Token which can be validated under
    $ curl -s -H "Authorization: Bearer svX8bE9HTiVpMr7r55TtKtcOkLRhAq1a" \
    https://{host}/.ory/kratos/public/sessions/whoami | jq


For more information, please check this `Guide <https://www.ory.sh/kratos/docs/guides/zero-trust-iap-proxy-identity-access-proxy#ory-oathkeeper-identity-and-access-proxy>`_
