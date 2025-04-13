## Replication Controller & Replicasets

Replicaion Controller와 Replicasets 모두 Pod에 대한 High-Availability, Load Banalance, Scale 등을 도와준다. `Replication Controller`는 일종의 레거시로서, 현재는 `Replicasets`로 대체되고 있는 추세이다. 두개의 차이점은 아래와 같다.

- API Version
  - Replication Controller: v1
  - Replicasets: apps/v1
- Replicaset은 `selector` 정의가 필요함
  Replication Controller는 template으로 정의한 Pod만 관리할 수 있다. 하지만 Replicasets는 selector를 통해 template을 통해 생성되지 않는 Pod도 관리할 수 있다.

## Replication Controller & Replicasets Declarative

```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: myapp-rc
  labels:
    app: myapp
    type: frontend
spec:
  template:
    metadata:
      name: myapp-pod
      labels:
        app: myapp
        type: frontend
    spec:
      containers:
        - name: nginx-container
          image: nginx
  replicas: 3

---
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: myapp-rs
  labels:
    app: myapp
    type: frontend
spec:
  replicas: 6
  selector:
    matchLabels:
      type: frontend
  template:
    metadata:
      labels:
        app: myapp
        type: frontend
    spec:
      containers:
        - name: nginx-container
          image: nginx
```

Replication Controller, Replicaset 모두 `spec` 하단에 공통적으로 두 필드를 정의한다.

- `template`
- `replicas`

`template`이라는 필드를 정의해줘야한다. 이는 관리할 Pod의 스펙을 정의하는 곳이다. `Pod`를 YAML로 정의한것에서 `metadata`와 `spec`부분만 `template`에 정의해주면 된다.

`replicas`는 총 몇개의 Pod가 복제되어 관리되야하는지 Desired State에 대한정의이다.

차이점이라면 `selector` 이다. 위에서 말했듯이 `Replicaset`의 경우에는 `selector`가 정의된다. `selector`에는 해당 Replicasets라는 Controller가 어떤 label을 통해서 관리할 Pod를 인식하는지를 정의한다. 이를 통해서 Replicaset의 template으로 생성된 Pod들도 Replicaset에 의해 관리될 수 있는것이다.

이것을 테스트 해보기 위해 먼저 `testing-pod.yaml`을 실행시킨다. 그리고 잘 실행됐는지 확인한다.

```
╰─ kubectl apply -f testing-pod.yaml
pod/myapp-pod created

╰─ kubectl get pods
NAME        READY   STATUS    RESTARTS   AGE
myapp-pod   1/1     Running   0          40s
```

그리고 나서 `replication-set.yaml`을 실행한다.

```
╰─ kubectl apply -f replication-set.yaml
replicaset.apps/myapp-rs created

╰─ kubectl get pods
NAME             READY   STATUS              RESTARTS   AGE
myapp-pod        1/1     Running             0          52s
myapp-rs-2fbqh   0/1     ContainerCreating   0          2s
myapp-rs-9wstq   0/1     ContainerCreating   0          2s
myapp-rs-fqr2p   0/1     ContainerCreating   0          2s
myapp-rs-wt99r   0/1     ContainerCreating   0          2s
myapp-rs-zs9bh   0/1     ContainerCreating   0          2s
```

`replication-set.yaml`을 보면 알 수 있듯이 replicas는 6으로 되어있다 하지만, 이미 myapp-pod에서 selector에 명시된 동일한 label을 가지고 있어 5개만 추가적으로 생성한것을 볼 수 있다.

## Controller에 의해 생성된 Pod는 해당 Controller를 통해서만 제어할 수 있다.

Controller들은 항상 정의된 Desired-State를 유지한다. 그렇기 때문에 Replicasets, Replication-Controller로 생성된 Pod를 지워도 replicas에 정의된 수량에 맞춰 Pod가 다시 생성된다.

또한 Replication Controller에서 생성된 Pod와 Replicasets의 selector에 정의된 label이 같더라도 Replication Controller에 의해 생성된 Pod는 Replicasets에 의해 영향을 받지 않는다.

## Imperative한 방법으로 Replicaset의 Replication 수 늘리기

`kubectl scale`을 활용하여 Replicaset의 Replicas를 변경할 수 있다.

- [공식문서](https://kubernetes.io/docs/reference/kubectl/generated/kubectl_scale/)

`kubectl scale`은 Replicasets뿐만 아니라 Deployments, Replication Controller, Stateful Set 등 Replicas를 사용하는 모든 컨트롤러들에 대해 사용할 수 있다.

예를 들어 위에서 `replication-set.yaml`를 통해 생성한 replicaset의 replicas를 8로 늘려본다고 가정하자.

```
╰─ kubectl scale replicasets.apps/myapp-rs --replicas=8
replicaset.apps/myapp-rs scaled

╰─ kubectl get pods
NAME             READY   STATUS    RESTARTS   AGE
myapp-pod        1/1     Running   0          12m
myapp-rs-2fbqh   1/1     Running   0          11m
myapp-rs-2kpn4   1/1     Running   0          4s
myapp-rs-9wstq   1/1     Running   0          11m
myapp-rs-dzkcg   1/1     Running   0          4s
myapp-rs-fqr2p   1/1     Running   0          11m
myapp-rs-wt99r   1/1     Running   0          11m
myapp-rs-zs9bh   1/1     Running   0          11m
```

새로 두개의 Pod가 생성된것을 볼 수 있다. **단 이런 Imperative한 방법은 실제 manifest파일에 적용되는것은 아니니 주의하자. 팀에서 협업을 할때 만약 이런 식으로 런타임에서 변경을 하면 팀원에게 전달이 안될 가능성이 높을 뿐더러, 추적도 되지 않는다.**
