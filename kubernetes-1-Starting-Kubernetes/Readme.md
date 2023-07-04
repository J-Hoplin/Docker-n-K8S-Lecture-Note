# 1. Starting Kubernetes

---

## Pre-Requisite

- Docker에 대한 개념을 알고있어야 합니다.

---

## Kubernetes?

Kubernetes는 컨테이너 오케스트레이션 도구이다. 조금더 자세히 정의하자면, 서버 자원 클러스터링, 마이크로서비스 구조의 컨테이너 배포, 재해복구 등 컨테이너 기반의 서비스 운영에 필요한 여러가지 기능을 폭 넓게 지원해주는 도구이다. 또한 이러한 기능이나 컴포넌트를 사용자가 쉽게 커스터마이징 할 수 있다는 장점도 존재한다.구글에 의해 첫 개발되었지만, 현재는 CNCF(Cloud Native Computing Foundation)에 의해 프로젝트가 관리되고 있다.

쿠버네티스를 사용하기 위해서는 PaaS(Platform as a Service, AWS, GCP, NCP...etc)를 사용해도 되며, On-Premise형태로 설치해서 사용해도 된다. 해당 강의에서는 Minikube, Multipass(Multi Node Clustering)를 사용하여 진행을 할것이다.

## Kubernetes 시작하기

쿠버네티스는 리소스를 `오브젝트`라는 형태로 관리를 한다. 오브젝트는 앞으로 볼 컨테이너의 집합인 `Pod`, 컨테이너 집합을 관리하는 `Replica Set`, 사용자인 `Service Account`등 쿠버네티스의 리소스들을 의미한다.

쿠버네티스에서 사용하기 위한 오브젝트를 살펴보자.

```
kubectl api-resources
```

```
NAME                              SHORTNAMES   APIVERSION                             NAMESPACED   KIND
bindings                                       v1                                     true         Binding
componentstatuses                 cs           v1                                     false        ComponentStatus
configmaps                        cm           v1                                     true         ConfigMap
endpoints                         ep           v1                                     true         Endpoints
events                            ev           v1                                     true         Event
limitranges                       limits       v1                                     true         LimitRange
namespaces                        ns           v1                                     false        Namespace

...
```

특정 오브젝트의 설명을 보고싶은 경우, 공식문서 혹은 아래 명령어를 사용하면 된다

```
kubectl explain (object name)
```

예시로 `pod`의 설명을 출력하고 싶다고 한다고 가정한다

```
kubectl explain pods
```

```
KIND:     Pod
VERSION:  v1

DESCRIPTION:
     Pod is a collection of containers that can run on a host. This resource is
     created by clients and scheduled onto hosts.

FIELDS:
   apiVersion	<string>
     APIVersion defines the versioned schema of this representation of an
     object. Servers should convert recognized schemas to the latest internal
     value, and may reject unrecognized values. More info:
     https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources

...

```

공식문서는 이 [링크](https://kubernetes.io/ko/docs/concepts/)를 참고한다. 쿠버네티스도 Docker와 동일하게 여러 명령어가 존재한다. `kubectl`이라는 명령어를 통해 쿠버네티스를 사용할 수 있으며, 대부분의 작업도 `kubectl`을 통해 실행할 수 있다.

쿠버네티스는 YAML파일을 통해 컨테이너 리소스를 생성 및 삭제할 수 있다. YAML파일은 컨테이너 뿐만 아니라 모든 리소스 오브젝트들에 대해 사용할 수 있다는것이 특징이다. 리소스 오브젝트를 예를 들면, 컨테이너의 Config, Secret value들을 YAML파일을 이용해서 정의할 수 있다. 실제로 쿠버네티스를 배포할 때도 YAML파일을 정의해 적용시키지는 방식으로 동작한다.

## 쿠버네티스의 컴포넌트

쿠버네티스 노드는 `워커 노드`와 `마스터 노드`로 나누어져 있다. `마스터 노드`는 쿠버네티스가 제대로 동작할 수 있도록 클러스터를 관리하는 역할을 한다. `워커 노드`에는 애플리케이션 컨테이너가 생성되게 된다.

결국 워커노드와 마스터 노드는 상호간 통신을 하게 된다. 대략적인 구성 요소간 통신을 살펴본다
![img](./imgs/1.svg)
마스터 노드와 워커노드는 구성 요소에 차이가 있다. 우선 마스터 노드부터 살펴본다

### Kubectl

kubectl : 앞에서 잠시 오브젝트 종류를 보기 위해 `kubectl`이라는것을 사용하였다. kubectl은 클러스터에 명령을 내리는 역할을 하며, 실행 명령 형태로 배포된다. 주로 API Server와 통신하게 된다.

### 마스터 노드

- API Server : `쿠버네티스 클러스터 중심 역할`을 하는 통로이다. `상태의 값을 저장하는 etcd와 통신하지만, 이외 요소들 또한 API Server를 중심으로 통신을 하게 되기에, 매우 중요`하다.

- etcd : `구성 요소들의 상태값이 저장되는 곳`이다. `etcd 이외의 요소들은 상태 값을 저장하지 않는다`. 그렇기에 etcd 정보만 있다면, 장애 상황에서도 클러스터를 복구할 수 있다. etcd의 특징 중 하나는 `key-value 저장소`이며, 이를 복제해 여러 곳에 저장하면, etcd 하나에서 장애가 나도 시스템 가용성 확보가 가능하다.

- Controller Manager : 컨트롤러 매니저는 쿠버네티스 클러스터의 오브젝트 상태를 관리한다. 대표적인 컨트롤러들을 살펴본다.(아래 나오는 오브젝트들은 추후 자세히 알아본다)

  - 노드 컨트롤러 : 워커노드와 통신이 되지 않는 경우, 상태체크와 복구를 한다
  - 레플리카셋 컨트롤러 : 레플리카셋에 요청받은 Pod 개수만큼 Pod를 생성한다.
  - 엔드포인트 컨트롤러 : Service와 Pod를 연결한다.

- Scheduler : 노드의 상태, 자원, 요구조건등을 고려해 Pod를 생성할 Worker Node를 결정 하고 할당한다.

### 워커노드

**워커노드에 있는 컴포넌트는 마스터 노드에도 존재한다는것을 알아두자**

- kubelet : Pod의 구성 내용을 받아, 컨테이너 런타임으로 전달하며, Pod 안의 컨테이너가 정상 작동하는지 모니터링 한다. kubelet은 컨테이너 생성 삭제뿐 아니라, 마스터 - 워커 간의 통신 역할도 담당하는 매우 중요한 컴포넌트이다. **kubelet이 정상적으로 작동하지 않으면, 클러스터에 정상적으로 연결되지 않을 수 있다**,

- Container Run Time(CRI) : Pod를 이루는 컨테이너 실행을 담당한다. 다양한 종류의 컨테이너가 문제없이 작동할 수 있게금 하는 표준 인터페이스이다. 대표적인 컨테이너 런타임으로는 Docker, Podman등이 있다.

- Pod : 한개 이상의 컨테이너로 단일 목적의 일을 하기 위해 모인 단위이다.

- CoreDNS : 쿠버네티스 클러스터 내에서 도메인 이름을 이용해 통신하는데 사용한다. 클러스터를 구성해 사용할때는 IP보다 DNS를 이용하는것이 일반적이며 더 편하다.
