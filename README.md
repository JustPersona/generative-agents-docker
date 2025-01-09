# JustPersona/generative-agents 전용 도커 이미지

[JustPersona/generative-agents](https://github.com/JustPersona/generative-agents)
프로젝트 서버를 쉽게 구성할 수 있는 도커 이미지입니다.

여기서는 도커 이미지에 대한 설명만을 다루며,
프로젝트에 최적화된 도커 구성 방법 및 프로젝트 구성에 대한 설명은
[프로젝트 저장소](https://github.com/JustPersona/generative-agents)를 참고해 주세요.



## How to use

> [!NOTE]
> [환경 변수](#environment-variables)를 참고하여 `.env` 파일을 수정합니다.

새 폴더를 만들고
[docker-compose.yml](https://github.com/JustPersona/generative-agents-docker/blob/main/docker-compose.yml)
파일을 생성한 후 [주요 명령어](#key-commands)로 컨테이너를 관리합니다.

### Key Commands

> [!NOTE]
> up/down 명령어는 `docker-compose.yml` 파일이 위치한 곳에서 실행합니다.

컨테이너를 관리하기 위한 도커 및 전용 명령어에 대한 설명입니다.

| Command                                       | Info                                      |
|-----------------------------------------------|-------------------------------------------|
| docker compose up -d                          | 컨테이너 실행                             |
| docker compose down                           | 컨테이너 중지                             |
| docker logs generative-agents                 | 컨테이너 로그 (`-f` 추가 시 실시간 출력)  |
| docker exec -it generative-agents api         | API 호출 (`-h` 추가 시 사용법 출력)       |
| docker exec -it generative-agents backend     | 프로젝트의 백엔드 서버 실행               |
| docker exec -it generative-agents compress    | 저장된 시뮬레이션 압축                    |



## Environment Variables

`.env` 파일 내 설정 가능한 환경변수 목록입니다.

| Variable                                | Info                                                            | Default Value                                         | Allowed Values        |
|-----------------------------------------|-----------------------------------------------------------------|-------------------------------------------------------|-----------------------|
| `PUID`                                  | 서버를 실행할 유저의 UID                                        | `1000`                                                | 1~                    |
| `PGID`                                  | 서버를 실행할 유저의 GID                                        | `1000`                                                | 1~                    |
| `CHOWN_ENABLED`                         | 볼륨(디렉토리) 소유권을 `PUID`:`PGID`로 변경                    | `true`                                                | Boolean               |
| `DOCKER_VERSION_CHECK_ENABLED`          | 컨테이너의 이미지가 최신 버전인지 체크                          | `true`                                                | Boolean               |
| `DVWA_SOURCE_DOWNLOAD_ENABLED`          | DVWA 소스코드 다운로드                                          | `true`                                                | Boolean               |
| `SERVER_ENABLED`                        | 프로젝트 서버 사용                                              | `true`                                                | Boolean               |
| `SERVER_INSTALL_ENABLED`                | 프로젝트 서버 설치                                              | `true`                                                | Boolean               |
| `SERVER_INSTALL_AWAIT`<sup>3</sup>      | 프로젝트 서버가 설치될 때까지 대기                              | `false`                                               | Boolean               |
| `SERVER_INSTALL_URL`                    | 설치할 프로젝트의 URL                                           | `https://github.com/JustPersona/generative-agents`    | GitHub Repository URL |
| `SERVER_UPDATE_ENABLED`                 | 프로젝트 서버 자동 업데이트                                     | `true`                                                | Boolean               |
| `SERVER_UPDATE_AWAIT`<sup>3</sup>       | 프로젝트 서버가 업데이트될 때까지 대기                          | `false`                                               | Boolean               |
| `VENV_INSTALL_ENABLED`                  | VENV 설치                                                       | `true`                                                | Boolean               |
| `VENV_INSTALL_AWAIT`<sup>3</sup>        | VENV가 설치될 때까지 대기                                       | `false`                                               | Boolean               |
| `FRONTEND_SERVER_ENABLED`               | 프론트엔드 서버 실행                                            | `true`                                                | Boolean               |
| `FRONTEND_SERVER_ROOT`<sup>1</sup>      | 프론트엔드 디렉토리 경로 지정                                   | `environment/frontend_server`                         | PATH                  |
| `BACKEND_SERVER_ROOT`<sup>1</sup>       | 백엔드 디렉토리 경로 지정                                       | `reverie/backend_server`                              | PATH                  |
| `OLLAMA_CONFIG_ENABLED`                 | Ollama 자동 구성                                                | `true`                                                | Boolean               |
| `OLLAMA_HOST`                           | Ollama 서버 IP                                                  | `ollama`                                              | IP, Domain, Hostname  |
| `OLLAMA_PORT`                           | Ollama 서버 포트                                                | `11434`                                               | Integer               |
| `OLLAMA_ACTION`<sup>4</sup>             | Ollama 모델을 어떤 방식으로 생성할 것인지                       | `pull`                                                | `pull`, `create`      |
| `OLLAMA_MODEL_NAME`<sup>4</sup>         | 설치 또는 생성할 모델명                                         | `llama3.2:1b`                                         | 4번 참고              |
| `OLLAMA_GGUF_DOWNLOAD_ENABLED`          | GGUF 파일 다운로드 (`OLLAMA_GGUF_PATH` 위치에 파일이 없는 경우) | `true`                                                | Boolean               |
| `OLLAMA_GGUF_DOWNLOAD_URL`              | 다운로드 가능한 파일의 URL                                      |                                                       | URL                   |
| `OLLAMA_GGUF_PATH`<sup>2</sup>          | GGUF 파일 경로                                                  | `persona.gguf`                                        | String                |
| `OLLAMA_MODELFILE_PATH`<sup>2</sup>     | `Modelfile` 경로                                                | `Modelfile`                                           | String                |

1. `data` 폴더 기준
2. `share` 폴더 기준
3. 다중 컨테이너로 서버 구성 시 중복 구성을 방지하기 위해 사용
4. `OLLAMA_ACTION` 값에 따른 `OLLAMA_MODEL_NAME`의 용도
    - `OLLAMA_ACTION` 값이 `pull`안 경우, `OLLAMA_MODEL_NAME` 값은 [공식 지원 모델](https://ollama.com/library)에서 지원하는 모델이여야 함
    - `OLLAMA_ACTION` 값이 `create`인 경우, `OLLAMA_GGUF_PATH`, `OLLAMA_MODELFILE_PATH` 경로의 파일을 사용하여 이름이 `OLLAMA_MODEL_NAME`인 모델 생성
