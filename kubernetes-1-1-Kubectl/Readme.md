# 1-1. Kubectl Command

---

`kubectl` 커맨드는 앞으로 모든 장에서 활용할 명령어이다. `kubectl`은 쿠버네티스 객체들을 생성하고 API와 상호작용하는데 사용되는 명령어이다.

해당 장에서는 `kubectl`커맨드에 대해 살펴볼 것이며, 어떤 플래그들이 있구나 정도만 보고 넘어가도 좋다.

## Namespace

쿠버네티스는 객체들을 관리하기 위한 `namespace`라는것을 제공한다. 쉽게 생각하면, 객체들의 집합을 담고있는 일종의 폴더로 생각하면 된다. `kubectl`은 기본적으로 `default namespace`를 통해 상호작용한다. 만약 다른 namespace와 상호작용하고 싶은 경우 `-n`플래그를 추가해준다. 예를 들면

```bash
kubectl get pods -n my-ns
```

라고 한다면 `my-ns`라는 namespace에서 pod의 리스트를 가져오는 것이다. 만약 모든 네임스페이스로부터 가져오고 싶다면 `--all-namespaces` 플래그를 추가해주면 된다.

## Kubernetes API 객체 조회

모든 쿠버네티스 객체들은 RESTful 리소스로 표현된다. 그리고 이를 쿠버네티스 객체(Kubernetes Object)라고 주로 명칭한다. Kuberentes 객체들 목록을 조회해보자. 아래 명령어는 쿠버네티스 객체를 명세할때 cheat-sheet로 사용하기 좋으니 알아두자.

```bash
kubectl api-resources

NAME                              SHORTNAMES   APIVERSION                             NAMESPACED   KIND
bindings                                       v1                                     true         Binding
componentstatuses                 cs           v1                                     false        ComponentStatus
configmaps                        cm           v1                                     true         ConfigMap
endpoints                         ep           v1                                     true         Endpoints
events                            ev           v1                                     true         Event
limitranges                       limits       v1                                     true         LimitRange
namespaces                        ns           v1                                     false        Namespace
nodes                             no           v1                                     false        Node

....
```

kubectl를 사용하여 쿠버네티스 객체를 조회하는 가장 기본적인 command는 `get`이다.

```
kubectl get (Resource name)
```

위와 같이 명령어를 실행하면 현재 네임스페이스에 존재하는 모든 리소스 목록을 조회할 수 있다. 한번 아래 명령어를 실행해본다(K3S-Virtual-Cluster를 사용하는 경우만)

```bash
kubectl get pods

NAME                                                     READY   STATUS    RESTARTS   AGE
prometheus-prometheus-node-exporter-zmc54                1/1     Running   0          12m
prometheus-kube-prometheus-operator-6dfc46454d-f98b8     1/1     Running   0          12m
prometheus-kube-state-metrics-5db49ccbb8-fxvkw           1/1     Running   0          12m
alertmanager-prometheus-kube-prometheus-alertmanager-0   2/2     Running   0          12m
prometheus-prometheus-kube-prometheus-prometheus-0       2/2     Running   0          12m
prometheus-grafana-5b55f9d866-slcm5                      3/3     Running   0          12m
prometheus-prometheus-node-exporter-775f7                1/1     Running   0          11m
```

혹은 특정 리소스만 조회하고 싶다면, 해당 리소스의 이름을 추가하여 조회할 수 있다

```bash
kubectl get (Resource name) (object name)
```

```bash
kubectl get pods prometheus-grafana-5b55f9d866-slcm5

NAME                                  READY   STATUS    RESTARTS   AGE
prometheus-grafana-5b55f9d866-slcm5   3/3     Running   0          14m
```

위 방식은 터미널에 간단히 출력하기 위해 생략된 정보들이 있다. 생략된 정보를 보기 위해서는 `-o` 플래그를 추가하면 되며, `wide`를 통해 더 많은 정보를, `json`, `yaml` 플래그를 추가해 객체를 JSON 혹은 YAML 형태로 조회할 수 있다.

```bash
kubectl get pods -o wide

NAME                                                     READY   STATUS    RESTARTS   AGE   IP              NODE            NOMINATED NODE   READINESS GATES
prometheus-prometheus-node-exporter-zmc54                1/1     Running   0          17m   192.168.64.28   master-node     <none>           <none>
prometheus-kube-prometheus-operator-6dfc46454d-f98b8     1/1     Running   0          17m   10.42.0.8       master-node     <none>           <none>
prometheus-kube-state-metrics-5db49ccbb8-fxvkw           1/1     Running   0          17m   10.42.0.6       master-node     <none>           <none>
alertmanager-prometheus-kube-prometheus-alertmanager-0   2/2     Running   0          16m   10.42.0.10      master-node     <none>           <none>
prometheus-prometheus-kube-prometheus-prometheus-0       2/2     Running   0          16m   10.42.0.11      master-node     <none>           <none>
prometheus-grafana-5b55f9d866-slcm5                      3/3     Running   0          17m   10.42.0.7       master-node     <none>           <none>
prometheus-prometheus-node-exporter-775f7                1/1     Running   0          16m   192.168.64.29   worker-node-1   <none>           <none>
```

```bash
kubectl get pods prometheus-grafana-5b55f9d866-slcm5 -o json

{
    "apiVersion": "v1",
    "kind": "Pod",
    "metadata": {
        "annotations": {
            "checksum/config": "62ed31159b37c126c98745957f450c972e2de1e3723f1c3b5676584000a32795",
            "checksum/dashboards-json-config": "01ba4719c80b6fe911b091a7c05124b64eeece964e09c058ef8f9805daca546b",
            "checksum/sc-dashboard-provider-config": "cb8809cd61fc21390d17e193c8833be879ba5c1f41c47352757b312278ca4c55",
            "checksum/secret": "e92bfbb962e1737dce37e505f382f4594ed2761d8ae0f6b9886b39b5b60653a6",
            "kubectl.kubernetes.io/default-container": "grafana"
        },
        "creationTimestamp": "2023-07-04T02:23:08Z",
        "generateName": "prometheus-grafana-5b55f9d866-",
        "labels": {
            "app.kubernetes.io/instance": "prometheus",
            "app.kubernetes.io/name": "grafana",
            "pod-template-hash": "5b55f9d866"
        },
        "name": "prometheus-grafana-5b55f9d866-slcm5",
        "namespace": "default",
        "ownerReferences": [
            {
                "apiVersion": "apps/v1",
                "blockOwnerDeletion": true,
                "controller": true,
                "kind": "ReplicaSet",
                "name": "prometheus-grafana-5b55f9d866",
                "uid": "aa3ca2ca-b30b-4985-8a4a-3f506dbf4aad"
            }

...
```

`kubectl`은 JSONPath 쿼리 언어를 지원한다. 이를 통해 객체의 특정 필드를 선택할 수 있다.([JSONPath에 대해](https://www.lesstif.com/dbms/jsonpath-54952418.html)) 예를 들어 Pod의 Cluster IP를 출력한다 가정하자

```bash
kubectl get pods prometheus-grafana-5b55f9d866-slcm5 -o jsonpath --template={.status.podIP}

10.42.0.7
```

특정 객체에 대해 자세한 정보를 얻고싶은 경우 `describe`를 쓰는것도 방법이다.

```bash
kubectl describe pods prometheus-grafana-5b55f9d866-slcm5

Name:             prometheus-grafana-5b55f9d866-slcm5
Namespace:        default
Priority:         0
Service Account:  prometheus-grafana
Node:             master-node/192.168.64.28
Start Time:       Tue, 04 Jul 2023 11:23:08 +0900
Labels:           app.kubernetes.io/instance=prometheus
                  app.kubernetes.io/name=grafana
                  pod-template-hash=5b55f9d866
Annotations:      checksum/config: 62ed31159b37c126c98745957f450c972e2de1e3723f1c3b5676584000a32795
                  checksum/dashboards-json-config: 01ba4719c80b6fe911b091a7c05124b64eeece964e09c058ef8f9805daca546b
                  checksum/sc-dashboard-provider-config: cb8809cd61fc21390d17e193c8833be879ba5c1f41c47352757b312278ca4c55
                  checksum/secret: e92bfbb962e1737dce37e505f382f4594ed2761d8ae0f6b9886b39b5b60653a6
                  kubectl.kubernetes.io/default-container: grafana
Status:           Running
IP:               10.42.0.7
IPs:
  IP:           10.42.0.7
Controlled By:  ReplicaSet/prometheus-grafana-5b55f9d866
Containers:
  grafana-sc-dashboard:
    Container ID:   containerd://b325ab21a7666e4d33124d28f7c1fca1ae8085aa312c97fc76c53420c57578eb
    Image:          quay.io/kiwigrid/k8s-sidecar:1.24.3
    Image ID:       quay.io/kiwigrid/k8s-sidecar@sha256:5af76eebbba79edf4f7471bf1c3d5f2b40858114730c92d95eafe5716abe1fe8
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Tue, 04 Jul 2023 11:23:15 +0900
    Ready:          True

...
```

## Kubernetes 객체 생성, 수정, 삭제

쿠버네티스 API 객체들은 JSON 혹은 YAML 파일로 표현한다. 파일을 통해 쿠버네티스 서버에 객체를 생성, 수정, 삭제할 수 있다. `apply` 커맨드를 사용하여 객체를 생성할 수 있으며, 동시에 수정도 가능하다(수정에 대한 것은 추후 Replicaset을 하며 볼 것이다).Readme와 동일한 디렉토리에 있는 [`example-pod.yaml`](./example-pod.yaml)를 생성해 본다.

### 객체 생성

우선 위에서 봤던 namespace를 활용해 본다. 예시 yaml은 새로운 Namespace를 생성하고, 해당 Namespace에 Pod를 생성한다.

```bash
kubectl apply -f example-pod.yaml

namespace/example-namespace created
pod/resource-example created
```

한가지 짚고 넘어가자면, `-f` 옵션은 file을 의미한다. 만약 `-k`플래그를 사용하면, 특정 디렉토리를 지정할 수 있다.

이제 Pod가 잘 생성되었는지 확인한다. 주의할 점은 방금 생성한 Pod는 default namespace에 생성된것이 아니므로, namespace를 지정해 주어야 한다는것이다.

```bash
kubectl get pods --namespace=example-namespace

NAME               READY   STATUS    RESTARTS   AGE
resource-example   1/1     Running   0          5m28s
```

만약 apply 커맨드가 어떻게 적용되는지 확인하고 싶다면, `--dry-run` 플래그를 사용하면 좋다.

### 객체 삭제

이제 객체를 삭제해보자. 객체를 삭제할때는 생성할때와 마찬가지로 파일로 삭제할 수 있으며, 단순히 명령어를 통해서 삭제할 수 도 있다. 두 방식 모두 동일하게 `delete`를 사용해서 객체를 삭제한다는 점은 같다.

파일을 통해 삭제하는 방법

```bash
kubectl delete -f example-pod.yaml
```

명령어를 통해 삭제하는 방법

```bash
kubectl delete pods resource-example -n example-namespace
```

## Debugging Commands

`kubectl`에는 컨테이너 디버깅이 가능한 커맨드도 있다. 우선 위에서 사용한 예시 pod를 다시 생성한다

```bash
kubectl apply -f example.pod.yaml
```

`-logs`명령어를 사용하면 컨테이너의 로그를 확인할 수 있다

```
kubectl logs (pod name)
```

```bash
kubectl logs resource-example -n example-namespace

> simple-api@1.0.0 api
> node app.js

Listening on port 3000
GET /health 200 4.468 ms - 12
GET /health 200 0.516 ms - 12
GET /health 200 0.492 ms - 12
GET /health 200 1.080 ms - 12
GET /health 200 0.448 ms - 12
GET /health 200 0.736 ms - 12
GET /health 200 0.632 ms - 12
GET /health 200 0.225 ms - 12
```

`exec`,`attach` 커맨드는 docker와 크게 다를것이 없다. 그렇기 때문에 형태만 보고 설명 없이 넘어간다.

```
kubectl exec -it (pod name) --bash

kubectl attach -it (pod name)
```

`cp`명령어를 통해 컨테이너에 파일을 붙여넣거나, 컨테이너로부터 파일을 가져올 수 있다

```bash
kubectl cp (pod name):(container file's directory) (file's directory of local machine to copy)
```

```bash
kubectl cp -n example-namespace resource-example:app.js $(pwd)/app.js
```

위와 같이 명령어를 실행하면, Readme디렉토리에 `app.js`라는 파일이 생성된것을 볼 수 있다.

`port-forward`커맨드를 사용하면 네트워크를 통해 Pod를 접근할 수 있다. 물론 뒤에서 `Service`, `Ingress`라는것을 통해 외부와 통신하는것을 보겠지만, 이는 단순히 `kubectl`을 통해 접속하는것이다.

```bash
kubectl port-forward (podname) (local port):(container port)
```

```bash
kubectl port-forward -n example-namespace resource-example 3000:3000


Forwarding from 127.0.0.1:3000 -> 3000
Forwarding from [::1]:3000 -> 3000
```

이제 `localhost:3000`으로 들어가면 아래와 같은 페이지가 나오는것을 볼 수 있을것이다.

![img](./img/1.png)

마지막으로 `top`명령어를 사용해서 각 Node 혹은 Pod의 리소스 양을 조회할 수 있다.

```bash
kubectl top pods --all-namespaces

NAMESPACE           NAME                                                     CPU(cores)   MEMORY(bytes)
default             alertmanager-prometheus-kube-prometheus-alertmanager-0   1m           27Mi
default             prometheus-grafana-5b55f9d866-slcm5                      7m           230Mi
default             prometheus-kube-prometheus-operator-6dfc46454d-f98b8     1m           26Mi
default             prometheus-kube-state-metrics-5db49ccbb8-fxvkw           1m           12Mi
default             prometheus-prometheus-kube-prometheus-prometheus-0       11m          418Mi
default             prometheus-prometheus-node-exporter-775f7                1m           8Mi
default             prometheus-prometheus-node-exporter-zmc54                1m           10Mi
example-namespace   resource-example                                         1m           43Mi
kube-system         coredns-77ccd57875-vkbn6                                 2m           17Mi
kube-system         local-path-provisioner-957fdf8bc-pqzfj                   1m           8Mi
kube-system         metrics-server-648b5df564-w5d69                          9m           20Mi
```

```bash
kubectl top nodes


NAME            CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
master-node     91m          4%     1866Mi          94%
worker-node-1   19m          1%     837Mi           42%
```
