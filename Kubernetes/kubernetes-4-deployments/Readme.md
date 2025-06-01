# Deployments

- [공식문서](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

일반적인 운영환경에서 컨테이너를 여러개 띄우는 이유를 생각해보면

1. `High Availability`: Pod를 여러 Node에 분산하여 운영
2. `Rolling Update`: 만약 새로운 Version이 나왔을때 한번에 모든 Pod를 업데이트 하는 방식이 아닌, 하나씩 업데이트 하는 `Rolling Update`를 하여 사용자가 사용하는데에 있어서는 영향을 안주도록 함.
3. `Roll Back`: 만약 배포된 버전에 치명적인 문제가 있는 등의 상황에서 이전 버전으로 롤백을 해야하는 상황

Deployments를 통해서 이러한 것들이 가능하다.

## Declarative Deployments

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-deployment
  labels:
    app: myapp
    type: frontend
spec:
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
        - name: nginx-container
          image: nginx
```

보면 알 수 있듯이 Deployments와 크게 다르지 않은것을 알 수 있다.
