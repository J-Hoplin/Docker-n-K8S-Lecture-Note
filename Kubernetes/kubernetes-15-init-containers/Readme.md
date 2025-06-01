# Init containers

[공식문서](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)

하나의 Pod안에 여러개의 컨테이너가 실행되는 형태를 앞에서 Sidecar Pattern을 통해서 보았다. Sidecar Pattern에서는 Pod내에 있는 모든 컨테이너가 항상 실행되고 있는 상태였다. 그리고 컨테이너중 하나라도 오류가 생기면, Pod가 restart된다.

Init Containers도 하나의 Pod안에 여러개의 컨테이너가 실행되는 형태이다. 다만 다른점은, Init Containers는 애플리케이션 실행 이전에, Code pull, DB 설정과 같이 애플리케이션 실행 이전에 실행되는 일회성 컨테이너들이라는 점에서 Sidecar Pattern과 다른점이 있다.

Init Containers는 목적이 1회성이기에, Kubelet에 의해 정기적으로 체크되는 Probe들이 모두 지원되지 않는다. 반대로 Sidecar Pattern의 컨테이너들은 모두 Probe 지원을 받는다.

## Declarative Pod에서 Init Container

Pod정의 파일에서 Init Container를 정의하려면 `spec.initContainers`에 정의해주면 된다. `spec.containers`에 정의하듯 컨테이너를 정의해주면 되며, 동일하게 배열이다.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: myapp
spec:
  containers:
    - name: myapp-container
      image: busybox:1.28
      command: ["sh", "-c", "echo The app is running! && sleep 3600"]
  initContainers:
    - name: init-myservice
      image: busybox:1.28
      command:
        [
          "sh",
          "-c",
          "until nslookup myservice; do echo waiting for myservice; sleep 2; done;",
        ]
    - name: init-mydb
      image: busybox:1.28
      command:
        [
          "sh",
          "-c",
          "until nslookup mydb; do echo waiting for mydb; sleep 2; done;",
        ]
```

## Init Container가 여러개인 경우 순차적으로 실행된다.

[공식문서](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/#differences-from-regular-containers)

위의 예시와 같이 만약 Init Container가 여러개 정의되어있는 경우에는 순차적으로 실행된다.
