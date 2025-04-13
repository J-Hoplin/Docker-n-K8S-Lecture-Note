# ETCD

ETCD는 Kubernetes Cluster, Master Node 컴포넌트중 하나로서, Key-Value Store형태의 데이터베이스이다.

## ETCD는 클러스터 전반적인 정보를 저장한다.

ETCD는 클러스터 내 여러 정보들을 저장하게 된다. 여기에 해당하는 정보들 예시로는

- Nodes
- PODs
- Configs
- Accounts
- Roles
- Bindings

등과 같이 다양한 정보들이 해당된다. **`kubectl get` 명령어로 가져오는 모든 값들은 이 ETCD에 저장되어있는 값들이다.**

새로운 노드를 추가하거나, 새로운 Replica를 생성하는 등 클러스터에 변화를 주게되면, 모두 ETCD에 저장되게 된다. ETCD에 완벽히 저장되었을때만 해당 변화가 클러스터에 적용되었다고 판단한다.

## K3S는 etcd가 존재하지 않는다.

ETCD는 K3S같은 경우 SQLite로 대체되어있다. SQLite는 기본적으로 고가용성 보장을 하지 않기때문에, 대규모 운영환경에서는 적합하지 않다. K3S에서는 단순 SQLite 파일에 저장하는 형태로 운영되며, 이는 순수히 K3S Server에 의해 제어된다. K8S의 경우에는 ETCD에 대한 별도 Pod가 있다는 점에서 차이점이 있는것이다.
