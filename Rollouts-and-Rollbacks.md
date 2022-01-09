# Rollouts

- For checking status of updates in Deployment -
  `kubectl rollout status deployment/<deployment_name>`

- For checking history of updates in Deployment -
  `kubectl rollout history deployment/<deployment_name>`

**Deployment Strategy (spec.strategyType in Deployment manifest)**

- Recreate -> All pods will be deleted, then all will be Recreated. --> Down time

- Rolling update -> Pods will be deleted & Recreated one by one without a down time.
  When we rollout an update, deployment creates a different replicaset with new changes &
  creates pods in new rs & accordingly deletes pods in old rs.

Rollback -
`kubectl rollout undo deployment/<deployment_name>`
