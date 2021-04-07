ORY technical details
=========================

Components of the deployment
----------------------------

Since we're exposing our services in the Internet, we need an Authentication and
Authorization system to prevent unwanted users to accessing our services.
Our Ingress controller, Ambassador API Gateway can control the access by using an
External Authentication Service resource (AuthService).

An AuthService is an API that has a verification endpoint, which determines if the user
can access this resource (returning `200` or not, `401`).
In this project, we rely on ORY ecosystem to enable authentication.
ORY is an open-source ecosystem of services with clear boundaries that solve
authentication and authorization.

From the ORY Ecosystem we use two services:
    - ORY Oathkeeper
    - ORY Kratos

* Although they were designed to work together, all ORY services are completely independent
from each other *

ORY Oathkeeper
--------------

ORY Oathkeeper is an Identity & Access Proxy (IAP) and Access Control Decision API that
authorizes HTTP requests based on sets of Access Rules. It functions as a centralized way to
manage different Authentication and Authorization methods, and inform the gateway, whether
the HTTP request is allowed or not.
The Oathkeeper serves perfectly as an Ambassador's External AuthService.

Zero-Trust and Unauthorized Resources
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Oathkeeper is rooted in the principle of "never trust, always verify,". This means that,
unless additional configuration is provided, the Oathkeeper will always block the incoming
request. In practice, **all endpoints exposed in Ambassador will be blocked by external
requests, until further configuration is made**.

ORY Kratos
----------

ORY Kratos is an API-first Identity and User Management system that is built according
to cloud architecture best practices. It allows a quick setup of different authentication
mechanisms, with minimum configuration.

Kratos comes with out-of-the box support for two authentication mechanisms:
    - Username / Password
    - OIDC (OpenID Connect / OAuth2)

Kratos UI
~~~~~~~~~

Bundled with Kratos, there is an UI that allows browser users to execute registration
and login flows.