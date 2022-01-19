# Network-Policy

The Network policy is created to restrict network access rules on pods.

**A Pod can have 2 policyTypes -** 
1. Ingress - Incoming traffic to pod 
2. Egress - Outgoing traffic from pod

- **Ingress**
    - Network-Policy for adding a policy to a DB pod to only accept traffic from api-pod -->

        ```YAML
        apiVersion: networking.k8s.io/v1
        kind: NetworkPolicy
        metadata:
            name: db-policy
        spec:
            podSelector:    # used for attaching this policy to a pod with given role.
                matchLabels:
                    role: db-pod
            policyTypes:
                - Ingress
            ingress:
                - from:
                    - podSelector: # required for adding permissions for a pod with given label to access our pod.
                        matchLabels:
                            role: api-pod
                    ports:
                        - protocol: TCP
                        port: 33032 
        ```

        But, above policy will allow all pod with label `role: api-pod` to acess DB pod.

    - What if we want to allow only pods in a particular namespace.

        ```YAML
        apiVersion: networking.k8s.io/v1
        kind: NetworkPolicy
        metadata:
            name: db-policy
        spec:
            podSelector:    # used for attaching this policy to a pod with given role.
                matchLabels:
                    role: db-pod
            policyTypes:
                - Ingress
            ingress:
                - from:
                    - podSelector: # required for adding permissions for a pod with given label to access our pod.
                        matchLabels:
                            role: api-pod
                    namespaceSelector: # required if want to allow pods in `prod` namespace. [The namespace should have a label `name: prod`]
                        matchLabels:
                            name: prod 
                    ports:
                        - protocol: TCP
                        port: 33032 
        ```

    - What if we want allow traffic from an IP.

        ```YAML
        apiVersion: networking.k8s.io/v1
        kind: NetworkPolicy
        metadata:
            name: db-policy
        spec:
            podSelector:    # used for attaching this policy to a pod with given role.
                matchLabels:
                    role: db-pod
            policyTypes:
                - Ingress
            ingress:
                - from:
                    - ipBlock:
                        cidr: 192.16.22.1/24 
                    ports:
                        - protocol: TCP
                        port: 33032 
        ```

    **Note: The array of rules in `spec.ingress.from` is a OR operations between all rules in array.**

- **Egress**

    - Network-Policy for adding a policy to a DB pod to only send traffic to api-pod -->

        ```YAML
        apiVersion: networking.k8s.io/v1
        kind: NetworkPolicy
        metadata:
            name: db-policy
        spec:
            podSelector:    # used for attaching this policy to a pod with given role.
                matchLabels:
                    role: db-pod
            policyTypes:
                - Egress
            egress:
                - to:
                    - podSelector: # required for adding permissions for a pod with given label to access a pod.
                        matchLabels:
                            role: api-pod
                    ports:
                        - protocol: TCP
                        port: 33032 
        ```

        But, above policy will allow only pods with label `role: api-pod` to be acessed by DB pod.


