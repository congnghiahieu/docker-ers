# Docker ERS Multi

## Intro

Phiên bản tích hợp **Docker compose** chạy đồng thời 3 tool: **Evomaster**, **Schemathesis**, **Restler**

Với sự kết hợp cùng **Docker compose**, Schemathesis, Evomaster và Restler sẽ được chia ra làm 3 service chạy đồng thời để thực hiện kiểm thử.

## Set up docker compose

Để chạy đồng thời các tools với Docker compose ta cần các điều kiện sau:

- Chỉ định đường dẫn output volume
- Chỉ định đường dẫn API Specification URL
- Chỉ định biến môi trường tương ứng mỗi service

### 1. Chỉ định đường dẫn output volume

Cần chỉ định 1 volume để lưu trữ kết quả đầu ra của 3 tool sau khi quá trình kiểm thử kết thúc.

Có thể tuỳ chỉnh tên của volume bằng `volumeName` (optional) và đường dẫn tới output folder ở máy host bằng `device` (required)

```shell
volumes:
  volumeName:
    driver: local
    driver_opts:
      o: bind
      type: none
      #Specify mount path to get result on your host machine
      # On Windows, you must use absolute path
      # On Linux or MacOS, you can use both absolute and relative path
      # Ex (on Windows): D:/Workspace/apiTesting/Docker-Concurrency/result
      # Ex (on Linux): /home/user/
      device: pathToYourVolumeFolderInHost
```

Example:

```
volumes:
  result:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: D:/Workspace/apiTesting/Docker/result
```

Với ví dụ trên, sau khi hoàn thành kiểm thử kết quả của mỗi tool sẽ được lưu trữ trong folder **result** với đường dẫn **D:/Workspace/apiTesting/Docker/result** và sẽ tạo ra 1 docker volume với tên **result**

### 2. Chỉ định đường dẫn API Specification URL

Cả 3 service đều sử dụng biến môi trường `API_SPEC_URL`, giá trị này được sử dụng để chỉ dẫn vị trí lưu trữ của file đặc tả định dạng **JSON** (hiện tại không thể sử dụng file được lưu trữ trong local)

```shell
# Schemathesis test service
  docker-schema:
    ...
    environment:
      - API_SPEC_URL=
# Evomaster test service
  docker-evo:
    ...
    environment:
      - API_SPEC_URL=
# Restler test service
  docker-restler:
    ...
    environment:
      - API_SPEC_URL=
```

Nếu chỉ định giá trị cho cả 3 biến môi trường `API_SPEC_URL` giống nhau thì sẽ thực hiện kiểm thử trên cùng 1 API. Hoàn toàn có thể chỉ định 3 giá trị khác nhau vì vậy sẽ thực hiện kiểm thử trên 3 API khác nhau

Giả định test cùng 1 API với API Specs URL: https://api.apis.guru/v2/specs/6-dot-authentiqio.appspot.com/6/openapi.json :

```shell
# Schemathesis test service
docker-schema:
    ...
    environment:
      - API_SPEC_URL=https://api.apis.guru/v2/specs/6-dot-authentiqio.appspot.com/6/openapi.json
# Evomaster test service
  docker-evo:
    ...
    environment:
      - API_SPEC_URL=https://api.apis.guru/v2/specs/6-dot-authentiqio.appspot.com/6/openapi.json
# Restler test service
  docker-restler:
    ...
    environment:
      - API_SPEC_URL=https://api.apis.guru/v2/specs/6-dot-authentiqio.appspot.com/6/openapi.json
```

### 3. Chỉ định biến môi trường

Ngoài sử dụng chung biến `API_SPEC_URL`, mỗi service sẽ có những biến môi trường riêng được chỉ định trong file tương ứng.

```shell
# Schemathesis test service
  docker-schema:
    ...
    env_file:
      - ./docker-schemathesis/schemathesis.env
# Evomaster test service
  docker-evo:
    ...
    env_file:
    - ./docker-evomaster/evomaster.env
# Restler test service
  docker-restler:
    ...
    env_file:
      - ./docker-restler/restler.env
```

Tham số `env_file` chỉ định đường dẫn tới file `.env` của mỗi service

Mỗi biến môi trường ánh xạ tới command option tương ứng khi chạy tool bằng `CLI`

Mapping:

1. [Schemathesis environment variables](./docs/SchemathesisEnvVar.md)
2. [Evomaster environment variables](./docs/EvomasterEnvVar.md)
3. [Restler environment variables](./docs/RestlerEnvVar.md)

### 4. Chạy Docker compose

Sau khi hoàn thành set up volume, API Specs URL, biến môi trường, đứng tại folder `docker-ers-multi`:

```shell
docker compose -f docker-compose.yml up
```

Khi các tool hoàn thành quá trình kiểm thử:

```shell
docker compose -f docker-compose.yml down
```
