# Generic Jenkinsfile

## Plugins

- GitHub Branch Source
- Remote Jenkinsfile Provider
- Dark Theme
- Locale
- Basic Branch Build Strategies

# Steps

- `Security -> Git Host Key Verification Configuration`
- `Appearance -> Dark Theme`, `Locale` - disable browsers language
- Setup ENVs in `System`:
  - `DOCKER_REGISTRY_URL`
  - `DOCKER_REGISTRY_USER`
  - `DOCKER_REGISTRY_PASS`
- add new `GitHub Organization`
  - setup `Remote Jenkinsfile Provider`
  - setup tag discovery
  - setup tag build strategy
  - setup scan time to something low

