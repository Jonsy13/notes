# Node affinity

There are 2 types of node affinity -
- requiredDuringSchedulingIgnoredDuringExecution
- preferredDuringSchedulingIgnoredDuringExecution

For adding a Node affinity in Pods - 

- requiredDuringSchedulingIgnoredDuringExecution

    ```
    spec:
        affinity:
            nodeAffinity:
                requiredDuringSchedulingIgnoredDuringExecution:
                    nodeSelectorTerms:
                    - matchExpressions:
                        - key: <KEY>
                        operator: <OPERATOR>
                        values:
                        - <value-1>
                        - <value-2>
    ```

- preferredDuringSchedulingIgnoredDuringExecution

    ```
    spec:
        affinity:
            nodeAffinity:
                preferredDuringSchedulingIgnoredDuringExecution:
                    - weight:1
                      preference:
                        - key: <KEY>
                          operator: <OPERATOR>
                          values:
                          - <value-1>
                          - <value-2>
    ```