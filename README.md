# IBM Security Verify Passkey Sample App project

An implementation of Apple Passkeys with IBM Security Verify as the relying party FIDO service.

## Getting started

The resource links in the prerequisites explain and demonstrate how you create a new tenant application and configure the security settings to enable FIDO to be used in the sample app.

### Prerequisites

- Getting started

> See [Before you begin](https://github.com/ibm-security-verify/webauthn-relying-party-server-swift/blob/main/README.md)

## Getting started
1. Open Terminal and clone the repository and open the project file in Xcode.
   ```
   git clone git@github.com:ibm-security-verify/webauthn-passkey-sample-ios.git
   xed .
   ```

2. In the project **Signing & Capabilities**, update the following settings to suit your development environment:
   - Bundle Identifier
   - Provisioning Profile
   - Associated Domains
   

   The value of the associated domain will contain the replying party identifier defined in step 5 of the **Configure FIDO2** section above.  For example: `webcredentials:example.com`
   
   Ensure an `apple-app-site-association` (AASA) file is present on your domain in the .well-known directory, and that it contains an entry for this app’s App ID for the webcredentials service.  For example:
     ```
     "webcredentials": {
        "apps": [ "TEAM.com.company.app" ]
    }
    ```
3. Open the **PasskeyApp.swift** file
4. Replace the **relyingParty** variable with the host name of the relying party.  For example: `example.com`.


## Resources
[Supporting Security Key Authentication Using Physical Keys](https://developer.apple.com/documentation/authenticationservices/public-private_key_authentication/supporting_security_key_authentication_using_physical_keys)

[Public-Private Key Authentication](
https://developer.apple.com/documentation/authenticationservices/public-private_key_authentication)

[W3C Web Authentication](https://www.w3.org/TR/webauthn-2/)
