# What is this?

This is a bash script that uses openssl to generate a wildcard certificate suitable for use in a local testing environment.

The intended use is for generation of certs that can be used to satisfy https during local development.

Sourced originally from: https://gist.github.com/mfdj/8277918


## Usage

	./wildcard.sh example.com

After use, the private key, CSR and Cert will be found in `./certs`

The contents of the cert can be checked with `openssl`:

	openssl x509 -in certs/example.com.crt -text -noout

	// Check just the signature algorithm - should be sha512WithRSAEncryption
	openssl x509 -text -in certs/example.com.crt | grep Signature

## Adding to Mac OS Keychain Access

As our cert is self-signed, we need to add it to Keychain Access and tell Mac OS that it can trust it.

Presuming you're on a Mac, this can be done at the command line using a command such as the following:

	sudo security add-trusted-cert -d  -k /Library/Keychains/System.keychain ./certs/example.com.crt

Or, if you'd like to do it the long way:

	open /Applications/Utilities/Keychain\ Access.app ./certs/example.com.crt

The cert should be visible in the `Certificates` category in the `login` keychain.

1. Select the newly imported certificate, which should appear at the bottom of the certificate list, and click the [ｉ] button

2. In the popup window, click the ▶ button to the left of `Trust`, and select `Always Trust` for `When using this certificate:`

3. Close the popup window

4. When prompted, enter your password again and click `Update Settings`

5. Close `Keychain Access`


## Convert crt / key to pem

		openssl x509 -in example.com.crt -out example.com.crt.pem -outform pem

		openssl rsa -in example.com.key -out example.com.key.pem -outform pem

## Further reading

* https://gist.github.com/jed/6147872
