# Docker ERS Single

## Intro

Đây là phiên bản tích hợp 3 tool: **Evomaster**, **Schemathesis**, **Restler** vào 1 Docker image và chạy tool thủ công bằng **CLI**

## Docker image

### 1. Pull from Docker Hub

Chạy lệnh sau để thực hiện pull:

```shell
docker pull hieucien/ers:1.0
```

### 2. Build from Dockerfile

Docker image có thể được build từ `Dockerfile` trong folder `docker-ers-single`

Đứng ở folder `docker-ers-single`và chạy lệnh sau để thực hiện build:

```shell
docker build --tag ers:1.0 -f Dockerfile .
```

## Run container

Sau khi có Docker image `hieucien/ers:1.0`, chạy lệnh sau để vào trong container:

```shell
docker run -it hieucien/ers:1.0
```

Để lưu trữ kết quả của sau khi chạy tool, thêm volume bằng tham số `-v`:

```shell
docker run -it -v pathToHostFolder:pathToContainerFolder hieucien/ers:1.0
```

Example:

```shell
docker run -it -v D:/Workspace/apiTesting/Docker/result:/home/result hieucien/ers:1.0
```

Thư mục làm việc mặc định của container là `home`, nhập lệnh `intro` để xem giới thiệu về các tool có trong container

## Alias

Container đã được cài đặt 1 số alias để thuận tiện cho việc sử dụng tool

Để xem file giới thiệu:

```shell
intro
```

Evomaster:

```shell
evomaster
```

Restler-Fuzzer:

```shell
restler
```

Schemathesis:

```shell
st
```

## Tools

Để thực hiện kiểm thử, khuyến khích chạy các tool theo thứ tự:

1. Schemathesis
2. Evomaster
3. Restler

Config options docs:

1. [Schemathesis config](./docs/Schemathesis.md)
2. [Evomaster config](./docs/Evomaster.md)
3. [Restler-Fuzzler config](./docs/Restler.md)
