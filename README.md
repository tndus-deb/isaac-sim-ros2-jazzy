# Isaac Sim 5.1.0 + ROS2 Jazzy Docker Environment

NVIDIA Isaac Sim 5.1.0 컨테이너 이미지 기반 ROS2 Jazzy 통합 Docker 환경 구성

팀원별 동일 개발 환경 구축 및 실행 목적

---

## 1. 파일 구성

```text
Dockerfile
entrypoint.sh
.dockerignore
README.md
```

```text
Dockerfile      : Isaac Sim 5.1.0 기반 ROS2 Jazzy 설치 이미지 정의
entrypoint.sh   : 컨테이너 시작 시 ROS2 Jazzy 환경 자동 source
.dockerignore   : Docker build 제외 파일 지정
README.md       : 빌드 및 실행 방법 정리
```

---

## 2. Docker 이미지 빌드

저장소 clone 및 이미지 build

```bash
git clone https://github.com/tndus-deb/isaac-sim-ros2-jazzy.git
cd isaac-sim-ros2-jazzy
docker build -t isaac-sim-ros2-jazzy:5.1.0 .
docker images | grep isaac-sim-ros2-jazzy
```

정상 빌드 확인 예시

```text
isaac-sim-ros2-jazzy   5.1.0
```

---

## 3. ROS_DOMAIN_ID 설정

ROS2 topic 통신을 위해 Jetson Thor와 Isaac Sim 컨테이너의 `ROS_DOMAIN_ID`를 동일하게 설정

Isaac Sim 컨테이너 실행 시 `docker run` 명령어에 설정

```bash
-e ROS_DOMAIN_ID=10
```

동일한 Domain ID 사용 시 ROS2 topic 통신 가능

```text
Jetson Thor ROS_DOMAIN_ID=10
Isaac Sim 컨테이너 실행 시 ROS_DOMAIN_ID=10
→ ROS2 topic 통신 가능
```

Domain ID 불일치 시 통신 분리

```text
Jetson Thor ROS_DOMAIN_ID=10
Isaac Sim 컨테이너 실행 시 ROS_DOMAIN_ID=11
→ ROS2 topic 통신 불가 또는 분리
```

팀원별 독립 실험 환경 예시

```text
suyeon     : ROS_DOMAIN_ID=10
seonhyeong : ROS_DOMAIN_ID=11
dongseon   : ROS_DOMAIN_ID=12
```

Jetson Thor와 연동할 컨테이너는 컨테이너 실행 시 Jetson Thor와 동일한 Domain ID 사용
---

## 4. 기본 컨테이너 실행

Volume 폴더 생성, 권한 설정, 컨테이너 실행

`isaac-sim-user`와 `ROS_DOMAIN_ID=10` 값은 사용자 및 Jetson Thor 설정에 맞게 수정

```bash
mkdir -p ~/docker/isaac-sim-user/cache \
         ~/docker/isaac-sim-user/computecache \
         ~/docker/isaac-sim-user/logs \
         ~/docker/isaac-sim-user/config \
         ~/docker/isaac-sim-user/data \
         ~/docker/isaac-sim-user/pkg

sudo chown -R 1234:1234 ~/docker/isaac-sim-user

docker run --name isaac-sim-user \
  -it \
  --gpus all \
  --network=host \
  -e ACCEPT_EULA=Y \
  -e PRIVACY_CONSENT=Y \
  -e ROS_DOMAIN_ID=10 \
  -v ~/docker/isaac-sim-user/cache:/isaac-sim/.cache:rw \
  -v ~/docker/isaac-sim-user/computecache:/isaac-sim/.nv/ComputeCache:rw \
  -v ~/docker/isaac-sim-user/logs:/isaac-sim/.nvidia-omniverse/logs:rw \
  -v ~/docker/isaac-sim-user/config:/isaac-sim/.nvidia-omniverse/config:rw \
  -v ~/docker/isaac-sim-user/data:/isaac-sim/.local/share/ov/data:rw \
  -v ~/docker/isaac-sim-user/pkg:/isaac-sim/.local/share/ov/pkg:rw \
  isaac-sim-ros2-jazzy:5.1.0
```

---

## 5. suyeon 컨테이너 실행 예시

```bash
mkdir -p ~/docker/isaac-sim-suyeon/cache \
         ~/docker/isaac-sim-suyeon/computecache \
         ~/docker/isaac-sim-suyeon/logs \
         ~/docker/isaac-sim-suyeon/config \
         ~/docker/isaac-sim-suyeon/data \
         ~/docker/isaac-sim-suyeon/pkg

sudo chown -R 1234:1234 ~/docker/isaac-sim-suyeon

docker run --name isaac-sim-suyeon \
  -it \
  --gpus all \
  --network=host \
  -e ACCEPT_EULA=Y \
  -e PRIVACY_CONSENT=Y \
  -e ROS_DOMAIN_ID=10 \
  -v ~/docker/isaac-sim-suyeon/cache:/isaac-sim/.cache:rw \
  -v ~/docker/isaac-sim-suyeon/computecache:/isaac-sim/.nv/ComputeCache:rw \
  -v ~/docker/isaac-sim-suyeon/logs:/isaac-sim/.nvidia-omniverse/logs:rw \
  -v ~/docker/isaac-sim-suyeon/config:/isaac-sim/.nvidia-omniverse/config:rw \
  -v ~/docker/isaac-sim-suyeon/data:/isaac-sim/.local/share/ov/data:rw \
  -v ~/docker/isaac-sim-suyeon/pkg:/isaac-sim/.local/share/ov/pkg:rw \
  isaac-sim-ros2-jazzy:5.1.0
```

---

## 6. seonhyeong 컨테이너 실행 예시

```bash
mkdir -p ~/docker/isaac-sim-seonhyeong/cache \
         ~/docker/isaac-sim-seonhyeong/computecache \
         ~/docker/isaac-sim-seonhyeong/logs \
         ~/docker/isaac-sim-seonhyeong/config \
         ~/docker/isaac-sim-seonhyeong/data \
         ~/docker/isaac-sim-seonhyeong/pkg

sudo chown -R 1234:1234 ~/docker/isaac-sim-seonhyeong

docker run --name isaac-sim-seonhyeong \
  -it \
  --gpus all \
  --network=host \
  -e ACCEPT_EULA=Y \
  -e PRIVACY_CONSENT=Y \
  -e ROS_DOMAIN_ID=11 \
  -v ~/docker/isaac-sim-seonhyeong/cache:/isaac-sim/.cache:rw \
  -v ~/docker/isaac-sim-seonhyeong/computecache:/isaac-sim/.nv/ComputeCache:rw \
  -v ~/docker/isaac-sim-seonhyeong/logs:/isaac-sim/.nvidia-omniverse/logs:rw \
  -v ~/docker/isaac-sim-seonhyeong/config:/isaac-sim/.nvidia-omniverse/config:rw \
  -v ~/docker/isaac-sim-seonhyeong/data:/isaac-sim/.local/share/ov/data:rw \
  -v ~/docker/isaac-sim-seonhyeong/pkg:/isaac-sim/.local/share/ov/pkg:rw \
  isaac-sim-ros2-jazzy:5.1.0
```

---

## 7. dongseon 컨테이너 실행 예시

```bash
mkdir -p ~/docker/isaac-sim-dongseon/cache \
         ~/docker/isaac-sim-dongseon/computecache \
         ~/docker/isaac-sim-dongseon/logs \
         ~/docker/isaac-sim-dongseon/config \
         ~/docker/isaac-sim-dongseon/data \
         ~/docker/isaac-sim-dongseon/pkg

sudo chown -R 1234:1234 ~/docker/isaac-sim-dongseon

docker run --name isaac-sim-dongseon \
  -it \
  --gpus all \
  --network=host \
  -e ACCEPT_EULA=Y \
  -e PRIVACY_CONSENT=Y \
  -e ROS_DOMAIN_ID=12 \
  -v ~/docker/isaac-sim-dongseon/cache:/isaac-sim/.cache:rw \
  -v ~/docker/isaac-sim-dongseon/computecache:/isaac-sim/.nv/ComputeCache:rw \
  -v ~/docker/isaac-sim-dongseon/logs:/isaac-sim/.nvidia-omniverse/logs:rw \
  -v ~/docker/isaac-sim-dongseon/config:/isaac-sim/.nvidia-omniverse/config:rw \
  -v ~/docker/isaac-sim-dongseon/data:/isaac-sim/.local/share/ov/data:rw \
  -v ~/docker/isaac-sim-dongseon/pkg:/isaac-sim/.local/share/ov/pkg:rw \
  isaac-sim-ros2-jazzy:5.1.0
```

---

## 8. ROS2 설치 및 Domain ID 확인

컨테이너 내부 확인 명령어

```bash
echo $ROS_DISTRO && echo $ROS_DOMAIN_ID && ros2 topic list
```

정상 출력 예시

```text
jazzy
10
```

ROS2 demo node 테스트

터미널 1

```bash
ros2 run demo_nodes_cpp talker
```

터미널 2

```bash
ros2 run demo_nodes_py listener
```

---

## 9. Isaac Sim Headless 실행

컨테이너 내부 실행 명령어

```bash
cd /isaac-sim && ./runheadless.sh --/app/livestream/publicEndpointAddress=100.101.200.121
```

정상 로드 확인 문구

```text
Isaac Sim Full Streaming App is loaded.
```

WebRTC Streaming Client를 통한 접속

---

## 10. 컨테이너 재접속

기본 재접속 명령어

```bash
docker start isaac-sim-user && docker exec -it isaac-sim-user bash
```

suyeon 컨테이너

```bash
docker start isaac-sim-suyeon && docker exec -it isaac-sim-suyeon bash
```

seonhyeong 컨테이너

```bash
docker start isaac-sim-seonhyeong && docker exec -it isaac-sim-seonhyeong bash
```

dongseon 컨테이너

```bash
docker start isaac-sim-dongseon && docker exec -it isaac-sim-dongseon bash
```

---

## 11. 컨테이너 중지 및 삭제

컨테이너 중지

```bash
docker stop isaac-sim-user
```

컨테이너 삭제

```bash
docker rm isaac-sim-user
```

이미지 삭제

```bash
docker rmi isaac-sim-ros2-jazzy:5.1.0
```

컨테이너 내부 작업 파일 삭제 가능성 존재  
중요 파일은 volume 폴더에 보관 필요

