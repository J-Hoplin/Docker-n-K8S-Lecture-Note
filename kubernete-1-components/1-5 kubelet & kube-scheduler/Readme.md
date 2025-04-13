# Kubelet

Kubelet은 각 노드들의 head역할을 한다. 일정 주기로 마스터 노드에 현재 노드의 컨테이너 상태를 일정 간격으로 보고한다.

또한 Kubelet은 Master Node로부터 명령을 받아 컨테이너를 생성하는 역할도 담당한다.

1. Kubelet은 kube-api-server를 통해 Worker Node를 등록한다.
2. kube-api-server는 kube-scheduler를 확인하여 해당 노드에 생성해야하는 Pod가 있으면 해당 Worker Node에 Pod를 생성 명령을 전달한다.
3. Kubelet은 지속적으로 Node내 Pod와 Node자체를 모니터링 한 후 Master Node에 주기적으로 보고한다.

# Kube Scheduler

Kube Scheduler는 Pod를 어떤 노드에 넣어야 하는지를 결정한다. Scheduler는 클러스터 내의 노드들의 리소스 상황들을 고려하고 혹은 Pod에 걸린 제약사항들도 고려하여 알맞은 노드에 컨테이너를 배치한다.

기본적인 내부 동작은

1. 리소스에 따른 노드 필터링
2. 노드 순위 정함
3. 배치

지만, 필요에 따라서 직접 스케줄러를 만들 수 도 있다.
