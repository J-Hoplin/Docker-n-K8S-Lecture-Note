# Node Selector & Node Affinity

## Node Selector

- [공식문서](https://kubernetes.io/ko/docs/concepts/scheduling-eviction/assign-pod-node/)

Pod가 스케줄될 Node를 선택하는 경우가 필요할때가 있다. 예를 들어서 노드마다 각각의 컴퓨팅 자원 사양이 다르고, 고사양 Container의 경우에는 중간 사양 이상의 노드에 스케줄 되어야 안정적이 운영이 가능하다.

Pod가 특정 노드에만 생성될 수 있게 하는 방법을 우리는 앞에서 보았다. 바로 `nodeName`을 통해서이다.

```yaml
spec:
  containers:
    - name: nginx
      image: nginx
  nodeName: master-node
```

하지만 이런 경우에는 한계가 있다. 사람이 일일히 노드 이름을 정의해주기 때문에 클러스터 내 노드 수가 많아진다면, 노드 자원 사용량에 따라 적당한곳에 배치하는것을 사람이 직접해야한다.

앞에서 Deployments, Replicaset에서 보았던것처럼 Node도 Label을 통한 선택이 가능하다. 그리고 이것을 `Node Selector` 라고 부른다.

`Node Selector`를 사용하기 위해서는 먼저 노드에 라벨을 붙여줘야한다. 현재 노드가 이렇게 존재한다고 가정한다.

```
kubectl get nodes

NAME       STATUS   ROLES                  AGE     VERSION
master     Ready    control-plane,master   5m31s   v1.30.11+k3s1
worker-1   Ready    <none>                 5m22s   v1.30.11+k3s1
worker-2   Ready    <none>                 5m8s    v1.30.11+k3s
```

이 상태에서 worker-2에 `color=green` 이라는 라벨을 우선 붙인다. 노드에 라벨을 붙일때는 `kubectl label`을 사용한다.

> kubectl label nodes (node nmae) (label-key)=(label-value)

```
kubectl label nodes worker-2 color=green

node/worker-2 labeled

kubectl describe nodes worker-2

Name:               worker-2
Roles:              <none>
Labels:             beta.kubernetes.io/arch=arm64
                    beta.kubernetes.io/instance-type=k3s
                    beta.kubernetes.io/os=linux
                    color=green
```

그리고 이제 단일 Pod가 스케줄링 될때 `color=green`이라는 라벨을 가진 노드에 스케줄링 될 수 있도록 해보자. Node Selector는 Pod spec의 `nodeSelector`필드에 key-value 형식으로 정의해주면 된다.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: node-selector-test
  labels:
    tier: test
spec:
  containers:
    - name: nginx-container
      image: nginx
  nodeSelector:
    color: green
```

```
kubectl apply -f ./manifest/node-selector.yaml

pod/node-selector-test created

kubectl get pods -o wide

NAME                 READY   STATUS    RESTARTS   AGE   IP          NODE       NOMINATED NODE   READINESS GATES
node-selector-test   1/1     Running   0          12s   10.42.2.4   worker-2   <none>           <none>
```

위 결과에서 볼 수 있듯이 해당 Pod는 `color=green`이라는 라벨을 가진 worker-2에 스케줄된것을 볼 수 있다.

### Node Selector의 한계

Node Selector를 통해 기존에 Node Name으로 노드를 스케줄링 하는것보다 훨씬 유연하게 할 수 있는 것을 보았다. 하지만 Node Selector에도 한계가 존재한다.

1. 만약 `color`태그의 값이 `green` 혹은 `blue` 인 노드에 대해 모두 스케줄링을 허용하는 경우에는 어떻게 될것인지
2. 만약 `color`태그의 값이 6개가 있는데 이중 `red`를 제외한 나머지 모두 유효하다면 어떻게 될것인지

와 같이 유동적인 범위 설정을 해야할때 한계가 있다. 이런 경우를 위해 사용하는것이 바로 `nodeAffinity`이다.

## Node Affinity

- [공식문서](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)

Node Affinity는 노드를 선택하는데 있어 고급기능을 제공한다. Node Affinity에는 크게 두가지 타입이 존재한다.

Node Affinity 를 해석하는 방법은 다음과 같다

```
(condition) - During - (when) - (condition) - During - Execution
```

- **requiredDuringSchedulingIgnoredDuringExecution**: 스케줄러는 정의된 스케줄 rule을 만나기 전까지는 스케줄 되지 않는다. Node Selector과 거의 유사하지만, Operator 제공 등 더 유연하게 선택할 수 있다.
- **preferredDuringSchedulingIgnoredDuringExecution**: 스케줄러는 정의된 스케줄 rule을 최대한 찾는다. 만약 못찾는경우에는 rule에 해당되지 않더라도 스케줄링한다.

두개 타입에서 공통적인 것은 `IgnoredDuringExecution` 부분이다. **아직 쿠버네티스에는 `IgnoredDuringExecution`만 존재하며, 이는 원래 label(rule)에 맞는 노드에 스케줄된 이후에 만약 해당 label이 변경되거나 다른 노드에 해당 label이 추가되더라도 Pod는 다시 스케줄링 되지 않고 자신이 있던 노드에서 그대로 동작한다는 의미이다.**

### Node Affinity 정의하기

Node Affinity를 정의해보자. Pod를 기준으로는 `.spec.affinity.nodeAffinity`에 정의해줄 수 있으며, Pod를 감싸는 Controller 기준으로는 `spec.template.spec.affinity.nodeAffinity`에 정의해줄 수 있다. 한번 `color=green` 혹은 `color=blue`인 Pod에 스케줄 할 수 있도록 Node Affinity를 활용해 Pod를 정의해본다.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: node-affinity-test
  labels:
    tier: test
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
          - matchExpressions:
              - key: color
                operator: In
                values:
                  - green
                  - blue
  containers:
    - name: nginx-container
      image: nginx
```

```
kubectl apply -f ./manifest/affinity.yaml
-> pod/node-affinity-test created

kubectl get pods -o wide
NAME                 READY   STATUS    RESTARTS   AGE   IP          NODE       NOMINATED NODE   READINESS GATES
node-affinity-test   1/1     Running   0          18s   10.42.2.6   worker-2   <none>           <none>
```

여기서 nodeAffinity를 설정하는 부분을 살펴보자.

```yaml
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
          - matchExpressions:
              - key: color
                operator: In
                values:
                  - green
                  - blue
```

`affinity.nodeAffinity`로 하는 이유는 여기서는 다루지 않겠지만 `Pod Affinity`라는것도 존재하기 때문이다.([공식문서](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)) 여기서 주목해야할 부분은 앞에서 봤던 Node Affinity의 타입중 하나인 `requiredDuringSchedulingIgnoredDuringExecution`과 `nodeSelectorTerms`의 정의 부분이다. 앞에서 보았던 Node Selector의 경우에는 단일 label을 입력하는 방식이었다면 Node Affinity에는 `key`에 대한 label을 검색하기 위한 `operator`와 `values`를 제공하고 있다.

위와 같이 정의된다면,

```
해당 Pod는 color라는 키의 Label을 가졌으면서 green, blue라는 value를 가지고 있는 Node중 하나에 배치된다 라는 의미가 되게 된다.
```

조금 더 확실히 보기 위해서 방금 생성한 Pod를 삭제하고 위 Pod정의를 이용한 Deployment를 정의해본다.

```
kubectl delete pods node-affinity-test
-> pod "node-affinity-test" deleted
```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deployment-affinity-test
  labels:
    tier: test
spec:
  replicas: 3
  selector:
    matchLabels:
      tier: test
  template:
    metadata:
      labels:
        tier: test
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
              - matchExpressions:
                  - key: color
                    operator: In
                    values:
                      - green
                      - blue
      containers:
        - name: nginx-container
          image: nginx
```

이제 이 Deployment를 실행해본다.

```
kubectl apply -f ./manifest/affinity-deployment.yaml

deployment.apps/deployment-affinity-test created

kubectl get pods -o wide

NAME                                        READY   STATUS    RESTARTS   AGE   IP          NODE       NOMINATED NODE   READINESS GATES
deployment-affinity-test-697b5766fb-q89gx   1/1     Running   0          5s    10.42.2.7   worker-2   <none>           <none>
deployment-affinity-test-697b5766fb-rgkvd   1/1     Running   0          5s    10.42.2.8   worker-2   <none>           <none>
deployment-affinity-test-697b5766fb-rkb74   1/1     Running   0          5s    10.42.2.9   worker-2   <none>           <none>
```

당연히 아직 worker-2에만 Pod가 스케줄링 된다. 이유는 아직 worker-2의 `color=green` label 외에는 따로 `color` key를 가진 node가 존재하지 않기 때문에 worker-2외에는 만족하는 노드가 없어 스케줄 되지 않는것이다.

일단 deployment를 삭제하고 worker-1에 `color=blue` label을 붙여주자. 그 후 다시 deployments를 적용해주자.

```
kubectl delete deployments.apps deployment-affinity-test
-> deployment.apps "deployment-affinity-test" deleted

kubectl label nodes worker-1 color=blue
-> node/worker-1 labeled

kubectl apply -f ./manifest/affinity-deployment.yaml
-> deployment.apps/deployment-affinity-test created
```

이제 한번 각각의 Pod가 어디 생성되었는지 살펴본다.

```
kubectl get pods -o wide

NAME                                        READY   STATUS    RESTARTS   AGE   IP           NODE       NOMINATED NODE   READINESS GATES
deployment-affinity-test-697b5766fb-4h5tl   1/1     Running   0          29s   10.42.2.11   worker-2   <none>           <none>
deployment-affinity-test-697b5766fb-7rdl9   1/1     Running   0          29s   10.42.1.6    worker-1   <none>           <none>
deployment-affinity-test-697b5766fb-tm8m7   1/1     Running   0          29s   10.42.2.10   worker-2   <none>           <none>
```

결과에서 볼 수 있듯이 worker-1, worker-2 모두에 스케줄된것을 확인할 수 있다. 이는 이제 worker-1에는 `color=blue`가, worker-2에는 `color=green`이 있기때문에 Node Affinity에 정의된 사항을 모두 만족하여 worker-1, worker-2에 스케줄링된 것이다.

### Node Affinifty Operator

위에서는 Node Affinity Operator의 `In`만 살펴보았지만, `In`외에도 다양한 Operator가 존재한다.

**[ `podAffinity`와 `nodeAffinity` 모두 사용가능 ]**

| Operator     | Behavior                                       |
| ------------ | ---------------------------------------------- |
| In           | 레이블 값이 제공된 문자열 집합에 존재함        |
| NotIn        | 레이블 값이 제공된 문자열 집합에 포함되지 않음 |
| Exists       | 이 키를 가진 레이블이 객체에 존재함            |
| DoesNotExist | 이 키를 가진 레이블이 객체에 존재하지 않음     |

**[ `nodeAffinity`에서만 사용가능 ]**

마크다운 표로 변환해드리겠습니다. Behavior 열의 내용을 한글로 바꾸었습니다:

| Operator | Behavior                                                                                 |
| -------- | ---------------------------------------------------------------------------------------- |
| Gt       | 필드 값이 정수로 파싱되며, 그 정수는 이 셀렉터로 지정된 레이블 값을 파싱한 정수보다 작음 |
| Lt       | 필드 값이 정수로 파싱되며, 그 정수는 이 셀렉터로 지정된 레이블 값을 파싱한 정수보다 큼   |
