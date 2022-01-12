# Ingress Setup using Self-signed Certificate -

## **CA key & CA certificate generation**

First, we have to create a certificate authority key & then create a certificate for the same -

- For creating CA key using openssl -

  ```BASH
  openssl genrsa -out ca.key 2048
  ```

  The output will look like this -

  ```BASH
  Generating RSA private key, 2048 bit long modulus (2 primes)
  ......+++++
  ........................+++++
  e is 65537 (0x010001)
  ```

- Now, we can generate out certificate using the same key (Change the CN & DNS to the configured domain) -

  ```BASH
  openssl req -x509 -new -nodes -key ca.key -sha256 -subj "/CN=18.134.5.83.nip.io" -days 1024 -out ca.crt -extensions san -config <(
  echo '[req]';
  echo 'distinguished_name=req';
  echo '[san]';
  echo 'subjectAltName=DNS:35.179.95.147.nip.io')
  ```

  This will create certificate - `ca.crt`

**OR**

We can create Key & Certificate using one command as well -

```BASH
openssl req -x509 -newkey rsa:4096 -sha256 -days 3560 -nodes -keyout ca.key -out ca.crt -subj '/CN=35.179.95.147.nip.io' -extensions san -config <(
  echo '[req]';
  echo 'distinguished_name=req';
  echo '[san]';
  echo 'subjectAltName=DNS:35.179.95.147.nip.io')
```

## **TLS secret creation**

Now, we can use these key & certificate for creating a tls certificate in k8s in your namespace where ingress will be configured -

```BASH
kubectl create secret tls ingress-local-tls \
  --cert=ca.crt \
  --key=ca.key -n litmus
```

## **Configure Ingress**

Add this secret like this in your ingress configuration -

```YAML
  tls:
    - hosts:
        - "35.179.95.147.nip.io"
      secretName: ingress-local-tls
```
