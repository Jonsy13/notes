# Using Self-signed certificate with Ingress

## Get a host name

If you already have a DNS name with you, then you can just add an entry with ingress-controller IP and map it to your DNS name.

OR 

For E.g., let's say IP of Ingress controller is - `34.162.139.34` or something

For using `https`, we need to have a domain name. We can use `nip.io` for DNS routing.

`nip.io` acts like a DNS server and sends any traffic coming on <SOME_IP>.nip.io to <SOME_IP>

So, in our case, hostname for our application will be `34.162.139.34.nip.io`

## Creating self-signed certificate configured for our host.

```BASH
openssl req -x509 -newkey rsa:4096 -sha256 -days 3560 -nodes -keyout tls.key -out tls.crt -subj '/CN=34.162.139.34.nip.io' -extensions san -config <( \
  echo '[req]'; \
  echo 'distinguished_name=req'; \
  echo '[san]'; \
  echo 'subjectAltName=DNS.1:localhost,DNS.2:34.162.139.34.nip.io')
```

Output - 

```
Generating a 4096 bit RSA private key
.................................................................................................++
.............++
writing new private key to 'tls.key'
-----

```

This will create 2 files - key and certificate. (tls.key and tls.crt)

In above command replace `34.162.139.34.nip.io` with your hostname.

## Creating TLS secret for using the same in ingress config.

```BASH
kubectl create secret tls ingress-local-tls \
  --cert=tls.crt \
  --key=tls.key -n litmus
```

## Next just configure your Ingress for using above secret for fetching certificate and add hostname in ingress.

e.g.

```YAML
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/tls-acme: "true"
    nginx.ingress.kubernetes.io/rewrite-target: /$1
  labels:
    app.kubernetes.io/component: hce-frontend
  name: litmus-ingress
  namespace: litmus
spec:
  ingressClassName: nginx
  rules:
  - host: 34.162.139.34.nip.io
    http:
      paths:
      - backend:
          service:
            name: hce-frontend-service
            port:
              number: 9091
        path: /(.*)
        pathType: ImplementationSpecific
      - backend:
          service:
            name: hce-server-service
            port:
              number: 9002
        path: /backend/(.*)
        pathType: ImplementationSpecific
  tls:
  - hosts:
    - 34.162.139.34.nip.io
    secretName: ingress-local-tls
```


