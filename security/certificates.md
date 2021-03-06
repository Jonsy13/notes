- For seeing the certificates in text form - 

    ```BASH
    openssl x509 -in <file_path> -text -noout
    ```

- For creating a csr using openssl - 

    ```BASH
    openssl genrsa -out myuser.key 2048
    openssl req -new -key myuser.key -out myuser.csr
    ```

- Create CSR kubeobject - 


    ```YAML
    apiVersion: certificates.k8s.io/v1
    kind: CertificateSigningRequest
    metadata:
        name: user_name
    spec:
        signerName: <signerName>
        request: --
        usages:
            - client-auth
    ```
    Note - The request can be generated by -> `cat myuser.csr | base64 | tr "\n"`

- Once we have created CSR, we can approve the same - 

    ```BASH
    kubectl certificate approve <csr_name>
    ```
- We can reject a CSR like - 

    ```BASH
    kubectl certificate deny <csr_name>
    ```