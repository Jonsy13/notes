# Role based access in k8s

## **Authorization**

There are different modes in which kube-apiserver can authorize users for different usecases.

- Node - Here, we use certificates to check authorization of user.
- ABAC - Here, we create policies for swapping users to different groups.
- RBAC - Here, we use roles/clusterroles for granting permissions to users.
- WebHook - Here, we use an external resource for authorization.
- AllowAny - Here, we allow everyone with all permissions. [Default one]
- DenyAny - Here, no permissions are given.

## **RBAC**

- **Roles/RoleBindings**

    - Used for giving namespaced scope permissions.
    - We can create roles for defining different permissions for differnt resources in different groups.
    - Then, we create rolebindings for swapping that role to a user or service-account.

    For e.g. - Role `developer` for giving permissions for creating pods in default namespace.

    ```YAML
    apiVersion: rbac.authorization.k8s.io/v1
    kind: Role
    metadata:
        name: developer
    spec:
        - apiGroups: [""]
          resources: ["Pods"]
          verbs: ["create"]
    ``` 

    Now, for adding user `dev-user-1` with this role, we can create rolebinding - 
    
    ```YAML
    apiversion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
        name: developer-role-binding
    spec:
        subjects:
            - name: dev-user-1
              kind: User
              apiGroup: rbac.authorization.k8s.io
        roleRef:
              name: developer
              kind: Role
              apiGroup: rbac.authorization.k8s.io
    ```

    **Note: Roles/ Rolebindings are Namespaced scoped**

- **ClusterRoles/ ClusterRoleBindings**

    - Used for cluster scoped permissions.
    - We can create roles for defining different permissions for differnt resources in different groups.
    - Then, we create rolebindings for swapping that role to a user or service-account.

    For e.g. - ClusterRole `admin` for giving permissions for creating pods in default namespace.

    ```YAML
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
        name: admin
    spec:
        - apiGroups: [""]
          resources: ["Nodes"]
          verbs: ["get"]
    ``` 

    Now, for adding user `admin-1` with this clusterrole, we can create clusterrolebinding - 
    
    ```YAML
    apiversion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
        name: admin-role-binding
    spec:
        subjects:
            - name: admin-1
              kind: User
              apiGroup: rbac.authorization.k8s.io
        roleRef:
              name: developer
              kind: ClusterRole
              apiGroup: rbac.authorization.k8s.io
    ```