# Schemathesis

Schemathesis đã được cài đặt sẵn trong Docker image bằng **pip**

```shell
python -m pip install schemathesis
```

Chú ý: Mặc định Schemathesis chỉ cho ra kết quả ở console nhưng có thể tuỳ chỉnh để lưu ra file

Để biết thêm thông tin [Schemathesis Document](https://schemathesis.readthedocs.io/en/stable/)

## Example

```shell
st run --checks all https://example.schemathesis.io/openapi.json
```

```shell
st run --verbosity --workers 8 --checks all --stateful=links https://api.apis.guru/v2/specs/6-dot-authentiqio.appspot.com/6/openapi.json
```

Chú ý: `st run --help` xem tất cả thông tin về tham số dòng lệnh.

## Tham số dòng lệnh

Chú ý: Dưới đây chỉ bao gồm các tham số hay sử dụng. Để biết thêm thông tin về các tham số khác [Schemathesis CLI options](https://schemathesis.readthedocs.io/en/stable/cli.html)

### 1. Sử dụng cơ bản

Để thực hiện test, sử dụng `st run`, ví dụ:

```shell
st run https://example.schemathesis.io/openapi.json
```

Mặc định Schemathesis sẽ sinh ra các tập test case, mỗi 1 tập test case tương ứng với 1 API operation, số lượng test case có trong 1 tập sẽ phụ thuộc vào độ lớn, phức tạp của API Specification và tối đa 100 test case / 1 tập test

### 2. Kiểm tra theo chỉ định

Mặc đinh Schemathesis sẽ kiểm tra tất cả các operations có trong API Specification, nhưng có thể lựa chọn endpoint hoặc method sẽ được kiểm tra

- `--endpoint / -E` : Operation path;
- `--method / -M` : HTTP method;

Ví dụ:

```
st run -E ^/api/users https://example.schemathesis.io/openapi.json
```

```
st run -M POST https://example.schemathesis.io/openapi.json
```

### 3. Lưu trữ test case

Schemathesis hỗ trợ lưu trữ thông tin các test case được thực hiện ra file thông qua tham số `--cassette-path`

Chú ý: Schemathesis sẽ hiện thị thông tin **tổng hợp** sau khi thực hiện toàn bộ test ra **console** (có thể lưu thành file) và thông tin test case **cụ thể** (bao gồm cả success và failure) sẽ được lưu vào file chỉ định bằng `--cassette-path`

```
st run --cassette-path=cassette.yaml http://127.0.0.1/schema.yaml
```

File YAML sẽ có định dạng như sau:

```
command: 'st run --cassette-path=cassette.yaml http://127.0.0.1/schema.yaml'
recorded_with: 'Schemathesis 1.2.0'
http_interactions:
- id: '0'
  status: 'FAILURE'
  seed: '1'
  elapsed: '0.00123'
  recorded_at: '2020-04-22T17:52:51.275318'
  checks:
    - name: 'not_a_server_error'
      status: 'FAILURE'
      message: 'Received a response with 5xx status code: 500'
  request:
    uri: 'http://127.0.0.1/api/failure'
    method: 'GET'
    headers:
      ...
    body:
      encoding: 'utf-8'
      string: ''
  response:
    status:
      code: '500'
      message: 'Internal Server Error'
    headers:
      ...
    body:
      encoding: 'utf-8'
      string: '500: Internal Server Error'
    http_version: '1.1'
```

### 4. Đọc file lưu trữ test case

Các file lưu trữ có thể được hiện thị bằng `st replay`, với những filters:

- `id` : Chỉ ra ID test case (1 test case bao gồm request và response tương ứng)
- `status` : Lọc ra test case có status `SUCCESS` hoặc `FAILURE` (**Chú ý: Có thể lọc ra các test case có status FAILURE và lưu thành 1 file riêng**
  )
- `uri`: Regex cho request URI
- `method`: Lọc theo method (GET, POST, ...)

Ví dụ:

```
$ st replay foo.yaml --status=FAILURE
Replaying cassette: foo.yaml
Total interactions: 4005

  ID              : 0
  URI             : http://127.0.0.1:8081/api/failure
  Old status code : 500
  New status code : 500

  ID              : 1
  URI             : http://127.0.0.1:8081/api/failure
  Old status code : 500
  New status code : 500
```

### 5. Tuỳ chỉnh số lượng test case tối đa

Schemathesis được xây dựng trên thư viện [Hypothesis](https://hypothesis.works/) nên có những tham số có tiền tố bắt đầu `--hypothesis`:

- `--hypothesis-max-examples=1000` : Sinh tối đa 1000 test case cho mỗi tập test

```
st run --hypothesis-max-exmaples=1000 ...
```

### 6. Tuỳ chỉnh kiểm tra response

Có 4 giá trị hợp lệ cho tham số `--checks / -c`:

- `not_a_server_error` : Kiểm tra response trả về có 5xx status code
- `status_code_conformance` : Kiểm tra response status code không khớp với định nghĩa trong specs
- `content_type_conformance` : Kiểm tra response content type không khớp với định nghĩa
- `response_schema_conformance` : Kiểm tra nội dung (content) response trả về không khớp định nghĩa

Để áp dụng cả 4 loại kiểm tra trên, sử dụng `--checks all`:

```
st run --checks all https://example.schemathesis.io/openapi.json
```

Ví dụ:

```
$ st run --checks all https://example.schemathesis.io/openapi.json
================ Schemathesis test session starts ===============
platform Linux -- Python 3.8.5, schemathesis-2.5.0, ...
rootdir: /
hypothesis profile 'default' -> ...
Schema location: https://example.schemathesis.io/openapi.json
Base URL: http://api.com/
Specification version: Swagger 2.0
Workers: 1
Collected API operations: 3

GET /api/path_variable/{key} .                             [ 33%]
GET /api/success .                                         [ 66%]
POST /api/users/ .                                         [100%]

============================ SUMMARY ============================

Performed checks:
    not_a_server_error              201 / 201 passed       PASSED
    status_code_conformance         201 / 201 passed       PASSED
    content_type_conformance        201 / 201 passed       PASSED
    response_schema_conformance     201 / 201 passed       PASSED

======================= 3 passed in 1.69s =======================
```

### 7. Tuỳ chỉnh thời gian phản hồi của 1 response

Nếu thời gian phản hồi vượt qua 1 ngưỡng nhất đinh sẽ bị coi như lỗi

- `--max-response-time=5000`: giá trị tính theo **milliseconds**

```
$ st run --max-response-time=50 ...
================ Schemathesis test session starts ===============
platform Linux -- Python 3.8.5, schemathesis-2.5.0, ...
rootdir: /
hypothesis profile 'default' -> ...
Schema location: https://example.schemathesis.io/openapi.json
Base URL: https://example.schemathesis.io/api
Specification version: Swagger 2.0
Workers: 1
Collected API operations: 1

GET /api/slow F                                            [100%]

============================ FAILURES ===========================
__________________________ GET /api/slow ________________________
1. Response time exceeded the limit of 50 ms

Run this Python code to reproduce this failure:

    requests.get('http://127.0.0.1:8081/api/slow')

Or add this option to your command line parameters:
    --hypothesis-seed=103697217851787640556597810346466192664
============================ SUMMARY ============================

Performed checks:
    not_a_server_error                  2 / 2 passed       PASSED
    max_response_time                   0 / 2 passed       FAILED

======================= 1 failed in 0.29s =======================
```

### 8. Kiểm tra đa luồng

Có thể tăng tốc độ kiểm tra bằng cách chỉ định nhiều luồng kiểm tra thông tin tham số `--workers / -w`:

```
st run --workers 8 https://example.com/api/swagger.json
```

Ở ví dụ trên, các test sẽ được chia ra 8 luồng (Việc chia luồng không chắc chắn đảm bảo tăng tốc độ thực hiện test vì phụ thuộc vào thiết bị)

### 9. Bỏ qua deprecated operations

Nếu API Specification bao gồm các deprecated operations (có trường `deprecated: true` trong định nghĩa), có thể bỏ qua việc kiểm tra bằng tham số `--skip-deprecated-operations`:

```
st run --skip-deprecated-operations ...
```

### 10. Chỉ định BASE URL

Nếu trong API Specification có định nghĩa `servers` (hoặc `basePath` với Swagger 2.0) thì giá trị (địa chỉ API server) sẽ được chỉ định để thực hiện toàn bộ test case. Tuy nhiên có thể sử dụng tham số `--base-url` để chỉ ra **base URL** khác so với trong API Specification:

```
st run --base-url=http://127.0.0.1:8080/api/v2 http://production.com/api/openapi.json
```

`--base-url` cũng có thể được sử dụng nếu muốn load API Specification từ local:

```
st run --base-url=http://127.0.0.1:8080/api/v1 path/to/openapi.json
```

### 11. Tuỳ chỉnh request header

Có thể tuỳ chỉnh request header (cần Authentication, ...) bằng tham số `-H`:

```
st run -H "Authorization: Bearer <token>" $SCHEMA_URL
```
