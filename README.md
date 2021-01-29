# Data Revenue - MLOps Reference Architecture

# Cluster installation
## AWS EKS
....

# Modules

## Jupyter Hub
...
### Configuration

The following table lists the configurable parameters of the jupyter-hub module and the default values.



| Parameter (* *required parameter*)                | Description                        | Default  |
| --------                 | --------                           | -------- |
|  **Proxy configuration**               |                        |           |          | 
| `jupyterhub_namespace`     | Namespace to install jupyterhb     | `jhub`     |
| `jhub_proxy_https_enabled` | Indicator to set whether HTTPS should be enabled or not on the proxy | `true` | 
| `jhub_proxy_https_hosts`   | You domains in list form. Required for automatic HTTPS | `[]` |
| `jhub_proxy_secret_token *`  | A 32-byte cryptographically secure randomly generated string used to secure communications between the hub and the configurable-http-proxy | `nil` |
| `jhub_proxy_https_letsencrypt_contact_email` | The contact email to be used for automatically provisioned HTTPS certificates by Let’s Encrypt | `""`| 
| **Authentication configuration**  |
| `oauth_github_enable` | Defines whether the authentication will be handled by github oauth. Required when `oauth_github_enable` is enabled| `false` | 
| `oauth_github_client_id **` | Github client id used on GitHubOAuthenticator. | `""`| 
| `oauth_github_client_secret **`| Github secret used to authenticate with github. Required when `oauth_github_enable` is enabled |  `""`| 
| `oauth_github_admin_users`| List of github user names to allow as administrator| `[]`|
| `oauth_github_callback_url`| The URL that people are redirected to after they authorize your GitHub App to act on their behalf | `""`|
| `oauth_github_allowed_organizations`|List of Github organization to restrict access to the members | `[""]`|


## Prefect
...
## Dask
...
## Feast
...
## MLFlow
...
## Seldon
...

