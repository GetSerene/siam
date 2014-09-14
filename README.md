NOTE:  This is work in progress at a very, very early stage ... still in the spiking/designing phase.  You cannot install and use this in your own apps yet.

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

Installing SIAMCLIENT, using in development
-------------------------------------------

Add the following to your Gemfile
```
gem 'siamclient'
gem 'siamserver', groups: [:development, :test]
```

and run
```
bundle install
```

Next create SIAM servers for the development and test environments.  By default the test and development SIAM servers are separate application services running on localhost at different ports than your rails app --- each is backed by a sqlite database.  Your test interactions are automatically recorded by VCR (we recommend checking the cassettes into source control) and the test server is only spun up when a test makes a request that cannot be satisfied by VCR.  By default, service discovery is not enabled in development and test and the ``config/siam.yml`` file contains explicit configuration information used by the servers when they start and the client when connecting. 
```
bin/rails generate siam:development
```

Start your server (if your server is already running you'll need to restart or the development SIAM server won't get started)
```
bin/rails s
```

You should see the siamserver starting up at 3010.  The client library will automatically try to register this application and/or update it with the SIAMSERVER according to the configuration generated in the last step.


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
