# Config Maps

Pod에 환경변수를 설정하는 방식은 간단하게 아래와 같이 container의 `env`에 정의해줄 수 있다.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-definition
spec:
  containers:
    - name: webapp-test
      image: nginx
      env:
        - name: SOME_ENV_1
          value: value1
        - name: SOME_ENV_2
          value: value2
```

하지만 이렇게 각 Pod별로 env를 정의해주다 보면, 환경변수 관리 포인트가 산발적이게 될 수 밖에 없다

## Config Map은 환경변수를 중앙 관리가 가능하도록 한다.

ConfigMap은 Key Value 쌍의 형태로 환경변수를 전달하는 역할을 한다. Pod가 생성되면, ConfigMap을 정의해서 환경변수를 주입할 수 있게된다.

[공식문서](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#configure-all-key-value-pairs-in-a-configmap-as-container-environment-variables)

## Config Map을 Imperative 하게 생성해보기

[공식문서](https://kubernetes.io/docs/reference/kubectl/generated/kubectl_create/kubectl_create_configmap/)

좋은 방식은 아니지만, Config Map 또한 Imperative 한 방식으로 만들 수 있다. `kubectl cretate configmap`을 활용하는 것이다.

- `--from-literal` 플래그 활용하기

  `--from-literal`은 각각의 Key-Value를 직접 정의하는 방식이다. `--from-literal=(Key)=(value)`형식으로 정의해주면 된다.

  ```
  ╰─ kubectl create configmap imperative-1 --from-literal=APP_COLOR=blue \
  --from-literal=APP_MODE=prod

  ╰─ kubectl describe configmaps imperative-1
    Name:         imperative-1
    Namespace:    default
    Labels:       <none>
    Annotations:  <none>

    Data
    ====
    APP_COLOR:
    ----
    blue
    APP_MODE:
    ----
    prod

    BinaryData
    ====

    Events:  <none>
  ```

- `--from-file` 플래그 활용하기
- `--from-env-file` 플래그 활용하기

## Config Map Declarative 하게 생성해보기

ConfigMap도 yaml 혹은 json 형식의 정의를 할 수 있다. 앞에서 봤던 object들과 다른 점이라면 `spec` 대신 `data`라는 필드가 존재한다는 점이다.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: declarative-config
data:
  APP_COLOR: green
  APP_MODE: prod
```

`data`에는 각각의 데이터를 Key Value형식으로 정의해준다.

```
╰─ kubectl describe configmaps declarative-config
Name:         declarative-config
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
APP_COLOR:
----
green
APP_MODE:
----
prod

BinaryData
====

Events:  <none>
```

## Declarative ConfigMap을 통해 Pod에 환경변수 주입하기

앞에서 봤듯이 ConfigMap은 Pod에 주입할 수 있다. 그렇다면 어떻게 주입할까?

[공식문서](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#configure-all-key-value-pairs-in-a-configmap-as-container-environment-variables)

Pod에서 ConfigMap을 주입할 수 있도록 하기 위해서는 각 컨테이너에 `envFrom.configMapRef`에 정의해주면 된다.

```yaml
envFrom:
  - configMapRef:
      name: pod-configs
```

공식문서에 적혀있듯이 **ConfigMap과 적용하려는 Pod는 항상 같은 Namespace에 존재해야한다**

> > You can write a Pod spec that refers to a ConfigMap and configures the container(s) in that Pod based on the data in the ConfigMap. The Pod and the ConfigMap must be in the same namespace.

`pod-with-config-map.yaml`을 활용해 실습해본다. 이 부분에서 핵심은 **`ConfigMap`의 name과 `Pod`의 `configMapRef`에 정의한 name이 일치해야한다**는 점이다.

```
╰─ kubectl apply -f pod-with-config-map.yaml
configmap/pod-configs unchanged
pod/some-pod created

╰─ kubectl logs pod/some-pod

... some other env

MODE=prod
COLOR=green

... some other env

```

해당 Pod는 일회 실행성이기 때문에 `logs`를 출력하면 환경변수에 `MODE`, `COLOR`가 들어가있는것을 볼 수 있다.

## Single Env각각 대입하기

`configMapKeyRef`를 활용하면 특정 ConfigMap에서 원하는 특정 Key의 값만 들고올 수 있게된다. `pod-with-configmap-key-ref.yaml`를 일부 가져와보자.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: pod-key-ref-configs
data:
  COLOR: green
  MODE: prod

---
containers:
  - name: simple-pod
    image: ubuntu
    env:
      - name: COLOR_KEY_NAME_CHANGED
        valueFrom:
          configMapKeyRef:
            name: pod-key-ref-configs
            key: COLOR
```

`configMapKeyRef`를 해석하는 방법은 다음과 같다.

- `spec.containers[0].env[0].name`: 해당 컨테이너 안에서 쓰일 환경변수 명
- `spec.containers[0].env[0].valueFrom.configMapKeyRef.name`: 참조할 ConfigMap 이름
- `spec.containers[0].env[0].valueFrom.configMapKeyRef.key`: Value를 가져올 참조한 ConfigMap의 Key

만약 위에처럼 정의되었을때는 아래와 같이 해석할 수 있다.

> simple-pod라는 pod에는 `COLOR_KEY_NAME_CHANGED`라는 환경 변수가 있고 이에 대한 값은 `pod-key-ref-configs`라는 ConfigMap의 `COLOR`라는 Key의 Value를 할당한다. 즉 Pod내에는 `COLOR_KEY_NAME_CHANGED`라는 Key가 `green`이라는

```
╰─ kubectl apply -f pod-with-configmap-key-ref.yaml
configmap/pod-key-ref-configs created
pod/pod-with-key-ref created

╰─ kubectl logs pod/pod-with-key-ref
green
```
