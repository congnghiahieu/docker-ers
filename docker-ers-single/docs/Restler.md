# Restler-Fuzzer

## Giới thiệu

Restler có 4 chế độ chạy (theo thứ tự):

- **Compile**: Compile 1 file specs ở định dạng JSON hoặc YAML thành 1 Folder Compile chứa các file cài đặt cần thiết để chạy 3 chế độ phía sau. Chi tiết về [Compiling](https://github.com/microsoft/restler-fuzzer/blob/main/docs/user-guide/Compiling.md).
- **Test**: Chế độ test đầu tiên, thực hiện kiểm tra nhanh tất cả các endpoint+method nhằm đảm bảo các endpoints đều có thể truy cập tới với cài đặt hiện tại. Mục đích của việc chạy chế độ này để nhanh chóng debug test setup. Chi tiết về [Test](https://github.com/microsoft/restler-fuzzer/blob/main/docs/user-guide/Testing.md) và [Engine setting](https://github.com/microsoft/restler-fuzzer/blob/main/docs/user-guide/SettingsFile.md).
- **FuzzLean**: Với mỗi endpoint+method thực hiện kiểm tra 1 lần với bộ test mặc định (được sinh ra khi Compile) để tìm lỗi nhanh chóng. Chi tiết về [FuzzLean](https://github.com/microsoft/restler-fuzzer/blob/main/docs/user-guide/Fuzzing.md).
- **Fuzz**: Thực hiện kiểm tra SUT dưới thời gian dài (theo giờ) để tìm được nhiều lỗi hơn so với **FuzzLean**. Chi tiết về [Fuzz](https://github.com/microsoft/restler-fuzzer/blob/main/docs/user-guide/Fuzzing.md).

Chú ý: Restler đã được set alias với Docker image pull từ Docker hub
`restler="/home/Restler-Fuzzer/restler_bin/restler/Restler"`

## Quick Tutorial

Phần demo này giống với phần demo của Restler-Fuzzer trong `intro.txt` và refer [A Quick RESTler Tutorial](https://github.com/microsoft/restler-fuzzer/blob/main/docs/user-guide/TutorialDemoServer.md)

Giả sử đã vào container bằng:

```shell
docker run -it hieucien/ers:1.0
```

### 1. Run demo server

- Tới demo_server directory: `cd /home/Restler-Fuzzer/demo_server`
- Tạo môi trường ảo: `python3 -m venv venv`
- Chạy môi trường ảo: `source venv/bin/activate`
- Cài đặt dependencies: `pip install -r requirements.txt`
- Đảm bảo đứng tại demo_server directory và chạy server: `python3 demo_server/app.py`

Note:

- Demo server chạy tại: http://localhost:8888/docs
- Thoát khỏi virtual environment: source venv/bin/activate.csh
- Server chạy với watch mode nên cần tạo 1 bash mới để thực hiện bước tiếp theo: (thoát khỏi container): `docker exec containerId bash`

### 2. Compile demo API specs

- Tạo 1 thư mục **demo-server-test**: `mkdir /home/Restler-Fuzzer/demo-server-test`
- Copy file demo **swagger.json**: `cp /home/Restler-Fuzzer/demo_server/swagger.json /home/Restler-Fuzzer/demo-server-test`
- Di chuyển tới **demo-server-test** dir: `cd /home/Restler-Fuzzer/demo-server-test`
- Thực hiện compile: `reslter compile --api_spec /home/Restler-Fuzzer/demo-server-test/swagger.json`

Đứng tại vị trí **demo-server-test**, sau khi thực hiện compile sẽ có folder `Compile` gồm các file sau:

- `grammar.py` và `grammar.json`: Restler grammars files
- `dict.json`: dictionary file chứa các tham số và giá trị mặc định tương ứng khi thực hiện test (có thể chỉnh sửa file này nếu muốn nhiều giá trị hơn)
- `engine_settings.json`: file chứa các engine_settings mặc định (là các tham số khi chạy CLI) (có thể chỉnh sửa)
- `config.json`: compiler configuration file

Ở ví dụ này sẽ sử dụng các giá trị mặc đinh và không thực hiện chỉnh sửa

### 3. Test method

Run:

```shell
restler test --grammar_file Compile/grammar.py --dictionary_file Compile/dict.json --settings Compile/engine_settings.json --no_ssl
```

Sau khi chạy sẽ tạo ra folder `Test`. Trong folder
`/home/Restler-Fuzzer/demo-server-test/Test/RestlerResults\experiment<...>\logs` chứa các files:

- `main.txt`: Liệt kê tất cả các API requests đã được thực hiện cùng với trạng thái **VALID** hoặc **INVALID**. Một **VALID** request có nghĩa là thực hiện thành công và nhận được status code **20x**. Độ bao phủ của specs (total spec coverage) hiện thị ở cuối file:

```shell
Final Swagger spec coverage: 5 / 6
```

- `network.testing.<...>.txt`: Chứa tất cả các request đã được thực hiện và response tương ứng

### 4. FuzzLean method

Run:

```shell
restler fuzz-lean --grammar_file Compile/grammar.py --dictionary_file Compile/dict.json --settings Compile/engine_settings.json --no_ssl
```

Sau khi chạy sẽ tạo ra folder `FuzzLean`. Trong folder
`/home/Restler-Fuzzer/demo-server-test/FuzzLean/RestlerResults\experiment<...>\`, `logs` dir chứa các files có ý nghĩa tương tự `Test` nhưng có thêm `bug_buckets` dir:

- `bug_buckets.txt`: Liệt kê các request / chuỗi request gây ra lỗi. Request nào có response mang status code _5xx_ sẽ được coi như lỗi.
- Có thể bao gồm các file dạng `*Checker*.txt` khác chứa các thông tin về lỗi khác. Chi tiết [FuzzLean bug_buckets](https://github.com/microsoft/restler-fuzzer/blob/main/docs/user-guide/Fuzzing.md)

### 5. Fuzz method

Run:

```shell
restler fuzz --grammar_file Compile/grammar.py --dictionary_file Compile/dict.json --settings Compile/engine_settings.json --no_ssl --time_budget 1
```

Có thêm tham số mới **--time_budget** chỉ định thời gian thực hiện Fuzz test (tính theo giờ)

Sau khi chạy sẽ tạo ra folder `Fuzz`. Trong folder
`/home/Restler-Fuzzer/demo-server-test/Fuzz/RestlerResults\experiment<...>\`, folder `logs` và `bug_buckets` tương tự như FuzzLean

Chú ý: Với những API nhỏ và không phức tạp thì chạy `Fuzz` chưa chắc đã tìm được thêm các lỗi so với chạy `FuzzLean`. Ngược lại với những API lớn, `Fuzz` sẽ giúp tìm được lỗi kĩ hơn

## Test your API

- Make sure your server is ready
- Compile you API specification
- Run 3 method: Test, FuzzLean, Fuzz

For more details, please visits: https://github.com/microsoft/restler-fuzzer

## Bugs found by RESTler

Có 2 thể loại bug khi sử dụng Restler:

- **Error code**: response status code **500**
- **Checkers**: Mỗi loại checkers trong sẽ tìm ra các lỗi khác nhau. Chi tiết về [Checkers](https://github.com/microsoft/restler-fuzzer/blob/main/docs/user-guide/Checkers.md)

## Cải thiện độ bao phủ (Specification coverage)

Khi test các API có thể gặp tính trạng All request failed (coverage equals zero) hoặc coverage thấp, việc này có thể do nhiều lí do: Fuzzing Dictionary (dict.json), Grammar (grammar.json), ...

Để cải thiện coverage [Quick Start for Fuzzing with RESTler](https://github.com/microsoft/restler-fuzzer/blob/main/docs/user-guide/QuickStart.md), [Improving API Coverage](https://github.com/microsoft/restler-fuzzer/blob/main/docs/user-guide/ImprovingCoverage.md)
