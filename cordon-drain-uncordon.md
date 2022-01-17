### When we drain a node, then all workfloads are terminated gracefully, get rescheduled on another node & the selected node is made unschedulable.

### When we cordon a node, then only node is made unschedulable.

### For making a node schedulable again, we have to use `uncordon`.