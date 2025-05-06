# Secrets

Secrets은 말그대로 환경변수지만 암호화가 필요한 등 중요하거나 민감한 키값들을 가리킨다. Secret도 ConfigMap과 동일하게 활용된다.

1. Secret 정의
2. Pod에 Secret 주입

또한 Secret도 ConfigMap과 동일하게 Imperative(`--from-literal`, `--from-file`), Declarative 방식 모두 생성할 수 있다.

## Declarative Secret

Declarative 방식도 ConfigMap과 동일한 형식이다. 단, data의 value들을 Base 64로 인코딩해서 넣어주어야 한다.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: some-secret
data:
  COLOR: Z3JlZW4=
  MODE: cHJvZA==
```

Unix/Linux 계열 시스템에서 문자열을 base64로 출력하기 위해서는 아래와 같이 명령어를 활용하면된다.

```
echo -n "(word or string)" | base64
```

> `-n` 옵션은 개행문자를 출력하지 않는다는 의미로서, secret을 인코딩 하기 위해서는 필수이다.

```
╰─ kubectl apply -f some-secret.yaml
secret/some-secret created

╰─ kubectl describe secret some-secret
Name:         some-secret
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
COLOR:  5 bytes
MODE:   4 bytes
```

Secret은 앞에서 봤던 ConfigMap과 다르게, 실제 값이 출력되지 않는것을 볼 수 있다.

## Inject Secret to Pod

Secret을 Pod에 주입하는 방법도 ConfigMap과 동일하다. `spec.containers[?].envFrom.secretRef`에 정의해주면된다.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: some-secret-2
data:
  COLOR: Z3JlZW4=
  MODE: cHJvZA==

---
apiVersion: v1
kind: Pod
metadata:
  name: some-secret-pod
spec:
  containers:
    - name: some-pod
      image: ubuntu
      envFrom:
        - secretRef:
            name: some-secret-2
```

`pod-with-somesecret.yaml`을 통해 실습해본다.

```
╰─ kubectl apply -f pod-with-somesecret.yaml
secret/some-secret-2 created
pod/some-secret-pod created

╰─ kubectl logs pod/some-secret-pod

...some other

COLOR=green

...some other

MODE=prod
```

여기서 알 수 있는것은, base64로 정의를 해도 주입될때는 decode가 되어 주입된다는 점이다.

## Single Secret Env to Pod

Secret에서 단일 key value만 pod에 주입하는것도 동일하게 된다. Secret에 대해 단일 Key Value를 주입하기 위해서는 `secretKeyRef`로 바뀐것을 제외하면 모두 동일하다.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: some-secret-3
data:
  COLOR: Z3JlZW4=
  MODE: cHJvZA==

---
apiVersion: v1
kind: Pod
metadata:
  name: some-secret-pod-key-ref
spec:
  containers:
    - name: some-pod
      image: ubuntu
      command: ["/bin/bash", "-c", "echo $MODE_KEY_SHOULD_BE_CHANGED"]
      env:
        - name: MODE_KEY_SHOULD_BE_CHANGED
          valueFrom:
            secretKeyRef:
              name: some-secret-3
              key: MODE
```

```
╰─ kubectl apply -f pod-key-ref-with-some-secret.yaml
secret/some-secret-3 created
pod/some-secret-pod-key-ref created

╰─ kubectl logs pod/some-secret-pod-key-ref
prod
```

## Secret 사용시 주의사항

1. Secret은 암호화되어있지 않으며, 단순히 encoded되어있는 상태이다. 누구나 secret자체는 쉽게 decode해서 볼 수 있기 때문에 주의해야한다.
2. Secret은 ETCD에서 암호화되지 않는다.
3. 동일한 네임스페이스에 Pod나 Deployment를 만들 수 있는 사람이라면 Secret은 모두 접근이 가능하다. 이를 방지하기 위해서는 RBAC등을 설정한다.
