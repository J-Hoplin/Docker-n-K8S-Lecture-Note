# Kube API Server

Kube API Server는 Kubernetes의 주요 구성 요소중 하나이다.

## `kubectl`은 Kube API Server와 통신한다.

`kubectl`명령어를 먼저 사용하게 되면, 요청이 가장 먼저 도착하는곳이 Kube API Server이다.
만약 `kubectl` 명령어를 사용해 단순 조회 명령을 한다면 아래와 같은 순서대로 진행된다. Kube API Server도 결국 API Server이다. 그렇기 때문에 `kubectl` 이 아닌 `curl`과 같은 명령어로도 조회할 수 있다.

```
curl -X POST /api/v1/~~~
```

1. 사용자 인증
2. Request 검증
3. ETCD로부터 데이터 조회 후 반환

반대로 Pod를 생성한다고 가정해보자.

1. 사용자 인증
2. Request 검증
3. ETCD에서 데이터 조회
4. ETCD 정보 업데이트
5. Kube Scheduler는 주기적으로 Kube API Server를 통해 데이터를 조회하고 새로운 노드에 대한 정보를 얻는다.
6. 해당 Pod가 생성되어야할 워커 노드를 선택한 후 Kube API Server로 요청을 보낸다.
7. Kube API Server는 생성될 워커 노드 위치 등의 정보를 저장하고 해당 워커노드 Kubelet에게 전달한다.
8. Kubelet은 전달받은 정보를 통해 Container Runtime에서 해당 이미지를 실행한다.
9. Kubelet은 생성한 후 생성 상태를 Kube API Server로 반환한다.
10. Kube API Server는 반환받은 상태를 ETCD에 저장한다.

만약 Pod 뿐만 아니라 클러스터 내 다른 구성요소에 대한 변화를 준다고 했을때 위와 크게 다르지 않은 방식으로 진행된다. 또한 Kube Scheduler, Control Manager도 클러스터에 변화를 줄 때는 Kube API Server를 거치게 된다.

**즉 Kube API Server는 클러스터내 특정 작업을 하는데 있어 중심이 되는 구성요소인 것이다.**
