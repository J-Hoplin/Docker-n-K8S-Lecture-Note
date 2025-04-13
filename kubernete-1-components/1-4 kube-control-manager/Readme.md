# Kube Control Manager

Kubernetes의 다양한 Controller들을 관리하는 매니저이다. 여기서 말하는 Controller란, `Replicaset`, `Deployment`, `Replication Controller` 등 모두 포함된다.

## Kube Control Manager는 전반적인 Controller들을 관리한다.

Kube Control Manager가 하는 역할은 다음과 같다.

1. Controller의 Status를 관찰한다.
2. 각 상황에 맞춰서 필요한 조치를 한다.

> Kubernetes에서 `Controller`란? 시스템 내 다양한 요소들을 지속적으로 모니터링하면서 시스템(클러스터)를 Desired State로 유지하는 일련의 과정을 의미한다.

Controller의 경우에는 필요에 따라 직접 만들 수 도 있다.
