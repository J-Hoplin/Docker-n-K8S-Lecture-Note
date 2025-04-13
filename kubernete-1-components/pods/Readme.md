# Pod

`Pod`는 쿠버네티스에서 생성할 수 있는 최소 단위이며, 이는 컨테이너를 감싸고 있다. Pod 내에는 컨테이너가 하나일 수도 여러개일 수 도 있다.(사이드카 패턴) 하지만 일반적으로는 하나의 Pod에는 하나의 컨테이너만 존재한다.

- [공식문서](https://kubernetes.io/docs/concepts/workloads/pods/)

## Generating Pod with Imperative Command

`Imperative Command`란 명령형으로 리소스를 생성하는 방식을 의미한다. 쿠버네티스에서 일반적인 명령형으로 리소스를 생성할때는 `kubectl`(Kubernetes Control)을 사용한다.

`Pod`를 kubectl로 생성할때는 `kubectl run`을 사용한다.

```
kubectl run nginx-pod --image nginx
```

- [공식문서](https://kubernetes.io/docs/reference/kubectl/generated/kubectl_run/)

가장 기본적인 사용방법으로는 Pod의 이름과 `--image` 플래그에 해당 Pod에서 사용될 container image를 지정해준다.

> 만약 Container Registry에서 해당 컨테이너 이미지를 못찾는 경우에는 `ImagePullBackOff` 라는 오류가 발생한다.

그리고 나서 Pod들의 목록을 조회할때는 `kubectl get`을 사용하여 리소스를 나열한다.

- [공식문서](https://kubernetes.io/docs/reference/kubectl/generated/kubectl_get/)

```
kubectl get pods
```

```
╰─ kubectl run nginx-pod --image nginx
pod/nginx-pod created

╰─ kubectl get pods
NAME             READY   STATUS    RESTARTS        AGE
nginx-pod        1/1     Running   0               5s
```

## Generating Pod with Declarative Way (YAML)

명령형과 반대로 선언형 리소스 생성도 가능하며, 쿠버네티스에서는 기본적으로 YAML, JSON포맷으로 리소스 선언을 지원한다. 이는 Pod 뿐만 아니라, Replicaset, Deployment, Stateful Set 등 모든 Kubernetes Resource들도 모두 해당된다. 기본적인 Pod 정의를 YAML로 작성해본다.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    app: nginx
    tier: frontend
spec:
  containers:
    - name: nginx
      image: nginx
```

먼저 각각의 필드가 어떤 역할을 하는지 알아본다.

### **apiVersion**

각 리소스에 맞는 apiVersion이 존재한다. `Pod`의 경우에는 `v1` apiVersion을 사용한다. 각 리소스를 정의할때 사용되는 `apiVersion`은 다르다. Kubernetes내에서 제공하는 리소스들의 `apiVersion`을 확인할떄는 아래 명령어를 사용한다. 아래에서 볼 수 있듯이 Pod는 `v1` 을 사용한다.

```
kubectl api-resources


# Result
╰─ kubectl api-resources
NAME                                SHORTNAMES   APIVERSION                        NAMESPACED   KIND
bindings                                         v1                                true         Binding
componentstatuses                   cs           v1                                false        ComponentStatus
configmaps                          cm           v1                                true         ConfigMap
endpoints                           ep           v1                                true         Endpoints
events                              ev           v1                                true         Event
limitranges                         limits       v1                                true         LimitRange
namespaces                          ns           v1                                false        Namespace
nodes                               no           v1                                false        Node
persistentvolumeclaims              pvc          v1                                true         PersistentVolumeClaim
persistentvolumes                   pv           v1                                false        PersistentVolume
pods                                po           v1                                true         Pod
podtemplates                                     v1                                true         PodTemplate
replicationcontrollers              rc           v1                                true         ReplicationController
```

### **kind**

kind는 해당 리소스가 어떤 객체인지를 명시해준다. 위 예시에서는 `Pod`를 명시해줬다.

### **metadata**

해당 리소스의 메타데이터들을 정의한다. 기본적으로 해당 리소스의 이름인 `name`, `labels`들을 정의해주며 `metadata`는 기본적으로 dictionary 형태로 정의된다.

`labels`에 명시된 라벨을 통해서 쿠버네티스는 클러스터 내에 있는 많은 리소스들간 Loosely Couple을 형성한다.(나중에 자세히)

### **spec**

`spec`은 각 리소스의 스펙 정의를 의미한다. `Pod`에서는 `containers`를 명시해줘야하며, 주의할점은 배열이라는 점이다. 배열인 점은 하나의 Pod에는 여러개의 Container가 들어갈 수 있기때문이다.

이제 정의된 YAML파일을 정의하기 위해서는 `kubectl apply`를 사용한다.

```
kubectl apply -f (파일명)
```
