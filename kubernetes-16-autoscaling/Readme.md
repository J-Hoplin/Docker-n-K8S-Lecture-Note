# AutoScaling

## Scaling이란?

Scaling이란 사전적 의미 그대로 확장을 의미한다.

### Horizontal Scaling vs Vertical Scaling

흔히 수직적 확장과 수평적 확장에 대한 이야기를 많이 한다. 하나의 서버에서 사용자가 많아져서 부하가 많아지면 결국 그만큼의 요청을 처리하는 리소스 양을 늘려야한다.

1. Vertical Scaling: 수직적 확장은 쉽게 말해 해당 서버의 하드웨어적 메모리나 CPU 등의 컴퓨팅 성능을 확장하는 방식을 의미한다.

   - Manually

     - `kubectl edit`을 활용하여 Relicaset/Deployment/Statefulset의 리소스 limit 양을 조절한다. ([공식문서](https://kubernetes.io/docs/reference/kubectl/generated/kubectl_edit/))

   - Automatically

     - ClusterAutoScaler([공식문서](https://kubernetes.io/docs/concepts/cluster-administration/node-autoscaling/)): Cloud Provider API와의 연동이 필요하다고 한다(혹은 Cloud Provider 내에서 제공)
     - VerticalPodAutoScaler([Github](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler))

2. Horizontal Scaling: 수평적 확장이란, 비슷한(혹은 다른) 성능의 서버를 여러개 두어서 컴퓨팅 자원을 확장하는 방식을 의미한다.

   - Manually

     - 쿠버네티스에서 클러스터에 노드를 추가하는 방식도 수평적 확장에 해당된다
     - `kubectl scale`을 활용하여 Replicaset 혹은 Deployment 내의 Pod 개수를 늘린다. ([공식문서](https://kubernetes.io/docs/reference/kubectl/generated/kubectl_scale/))

   - Automatically
     - HorizontalPodAutoScaler ([공식문서](https://kubernetes.io/ko/docs/tasks/run-application/horizontal-pod-autoscale/))

## Horizontal Pod AutoScaler

[공식문서](https://kubernetes.io/ko/docs/tasks/run-application/horizontal-pod-autoscale/)

### Imperative Way

Pod의 Horizontal AutoScale을 위해서는 `kubectl autoscale` 명령어를 사용한다. 예를 들어 아래와 같이 일반적인 Deployment가 정의되어있다고 가정하자

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  labels:
    tier: test
spec:
  replicas: 2
  selector:
    matchLabels:
      tier: test
  template:
    metadata:
      labels:
        tier: test
    spec:
      containers:
        - name: nginx-container
          image: nginx
          resources:
            requests:
              cpu: "250m"
            limits:
              cpu: "500m"
```

만약 이 상태에서 아래와 같이 autoscale을 설정한다고 가정하자.

```
kubectl autoscale deployment my-app --cpu-percent=50 --min=1 --max=10
```

위와 같이 설정되면, 우선 Deployment에 설정된 replicas는 무시되게 된다. 그리고 같은 이름의 HorizotnalAutoScaler(hpa)가 생성된다.

```
╰─ kubectl apply -f normal-deployment.yaml
deployment.apps/my-app created

╰─ kubectl autoscale deployment my-app --cpu-percent=50 --min=1 --max=10
horizontalpodautoscaler.autoscaling/my-app autoscaled

╰─ kubectl get hpa
NAME     REFERENCE           TARGETS              MINPODS   MAXPODS   REPLICAS   AGE
my-app   Deployment/my-app   cpu: <unknown>/50%   1         10        0          5s
```

그렇다면 동작은 어떻게 될까? HPA는 우선 컨테이너의 리소스 Limit을 살펴본다. 그 후 Metrics Server를 통해 해당 리소스가 사용하고 있는 리소스 양을 체크한 다음에 Scale을 진행하게 된다. 기본적으로 15초 간격으로 체크하게 된다.

### Declarative Way

HPA를 선언적 방법으로 정의해보자.(`horizontal-pod-autoscaler.yaml`참고)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-hpa-app

---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: my-hpa-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-hpa-app
  minReplicas: 1
  maxReplicas: 2
```

우선 `spec.scaleTargetRef`에는 해당 HPA가 적용될 Deployment를 명시한다. 여기서 알 수 있듯이 Deployment뿐만 아니라 Statefulset, Replicaset과 같은 다른 Controller나 Object도 가능하며, 적용하려는 name이 동일해야한다는 점도 알 수 있다.

그리고 Scale되는 조건에 대한 명시를 살펴보자.

```yaml
metrics:
  - type: Resource
    resources:
      name: cpu
      target: Utilization
      averageUtilization: 50
```

`spec.metrics.type`은 공식문서에도 나와있듯이 `Resource` 뿐만 아니라 `ContainerResource`도 존재한다.
또한 여기서는 다루지 않지만 `spec.behavior`에 `scaleUp`과 `scaleDown`에 대한 행동도 정의해줄 수 있다. ([공식문서](https://kubernetes.io/ko/docs/tasks/run-application/horizontal-pod-autoscale/#%EC%8A%A4%EC%BC%80%EC%9D%BC%EB%A7%81-%EC%A0%95%EC%B1%85))
