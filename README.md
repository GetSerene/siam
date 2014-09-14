NOTE:  This is work in progress at a very, very early stage ... still in the spiking/designing phase.

SIAM
====

Serene Identity and Access Management (SIAM) provides a simple service for service oriented architectures.

Goals
-----
- Incredibly easy and quick to integrate into a new Rails 4.2+ project, especially for novice Rails developers
- Trivial to move to another server
- Easy rspec integration
  - Full interface is mocked
  - Hooks for integration testing
- Provides single sign on (SSO) across apps
- Variety of sign on widgets
- Multi-factor authentication or at least out of band authentication


Architecture Notes
-------------------------

Open source replacement for enterprise services from [Amazon](http://aws.amazon.com/iam/), [IBM](http://www-935.ibm.com/services/us/en/it-services/security-services/identity-and-access-management-services/), [HP](http://www8.hp.com/us/en/business-services/it-services.html?compURI=1079088#.VBHWEy5dXGw), etc.

Stories
-------
- developer adds SIAMCLIENT to APPSERVICE
- APPSERVICE starts up and waits for SIAMSERVER to appear (discovers as soon as it appears)
- SIAMSERVER moves and APPSERVICE automatically adjusts
- APPSERVICE registers with SIAMSERVER and gets its credentials
- APPSERVICE cruds an ACCESSGROUP on the SIAMSERVER for use in APPSERVICE ACLS
- CLIENT grants APPSERVER access to PROFILE information
- APPSERVICE authenticates CLIENT through SIAMSERVER
- APPSERVICE authorizes CLIENT access to a resource through SIAMSERVER

Authentication Flow
-------------------
```
    CLIENT                APPSERVICE               SIAMSERVER                 
      +-----GET login-------> +
                             /
                            /
      + <---302 to-siam----/
       \
        \
         \--GET auth \c appID and redirecturl-------> +
                                                     /
                                                    /
      + <---200 grant form (or login if !loggedin)-/
       \
        \
         \--POST grant------------------------------> +
                                                     /
                                                    /
      + <---302 redirecturl /c 1-use key-----------/
       \
        \
         \--GET auth /c key---> +
                                 \
                                  \---1-time key-----> +
                                                      /
                                + <---auth-----------/
                               /
      + <---200 session cookie/
```

Related: [doorkeeper-provider-app](https://github.com/doorkeeper-gem/doorkeeper-provider-app)
