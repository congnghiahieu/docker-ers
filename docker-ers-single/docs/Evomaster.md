# Evomaster Black-Box Testing

Evomaster cho phép cài đặt giá trị cho các tham số trước khi chạy test, dưới đây là 1 vài tham số quan trọng được sử dụng

Để biết thêm thông tin về các tham số khác [Evomaster Command-line Options](https://github.com/EMResearch/EvoMaster/blob/master/docs/options.md).

Với Docker image được lấy về từ Docker Hub đã được cài sẵn alias cho Evomaster:
`evomaster="java -jar /home/Evomaster/evomaster.jar"`

Danh sách các tham số cũng có thể được hiện thị bằng `--help`:

```shell
evomaster --help
```

Chú ý: Khi sử dụng các tham số phải có tiền tố `--`, ví dụ: `--maxTime`

## Example

```shell
evomaster --blackBox true --outputFormat JAVA_JUNIT_4 --maxTime 1h15m30s --ratePerMinute 60 --outputFolder result/junit4 --bbSwaggerUrl https://api.apis.guru/v2/specs/6-dot-authentiqio.appspot.com/6/openapi.yaml
```

## Những tham số dòng lệnh quan trọng

| Options         | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| --------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `problemType`   | **Enum**. Thực hiện test trên Rest API hay GraphQL. Khi thực hiện Black-Box Testing nếu không chỉ ra tham số này thì giá trị mặc định là `REST`. _Hợp lệ_: `DEFAULT, REST, GRAPHQL`. _Mặc định_: `DEFAULT`.                                                                                                                                                                                                                                                                                                                                                                                         |
| `outputFolder`  | **String**. Đường dẫn tới thư mục chứa kết quả (có thể sử dụng cả đường dẫn tuyệt đối và tương đối). _Mặc định_: `src/em`.                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| `maxTime`       | **String**. Thời gian thực hiện test. Thời gian có thể biểu diễn theo giờ (`h`), phút (`m`) và giây (`s`), ví dụ: `1h10m120s` hoặc `72m` đều tương tự. Không cần thiết điền đẩy đủ cả 3 định dạng (i.e., `h`, `m` and `s`) nhưng ít nhất 1 định dạng phải được chỉ ra, ví dụ: Nếu muốn chạy test trong vòng 30 giây, có thể viết `30s` thay cho `0h0m30s`.**Ràng buộc**: `regex (\s*)((?=(\S+))(\d+h)?(\d+m)?(\d+s)?)(\s*)`. _Mặc định_: `60s`. **Chú ý: Thời gian càng lớn số lỗi phát hiện được càng nhiều, thời gian khuyến khích từ 1 giờ đến 24 giờ tuỳ thuộc vào độ lớn và phức tạp của API** |
| `outputFolder`  | **String**. Đường dẫn tới thư mục chứa kết quả (có thể sử dụng cả đường dẫn tuyệt đối và tương đối). _Mặc định_: `src/em`.                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| `outputFormat`  | **Enum**. Định dạng kết quả đầu ra. Khi thực hiện Black-Box Testing thì bắt buộc phải chỉ ra đinh dạng kết quả đầu ra . _Giá trị hợp lệ_: `DEFAULT, JAVA_JUNIT_5, JAVA_JUNIT_4, KOTLIN_JUNIT_4, KOTLIN_JUNIT_5, JS_JEST, CSHARP_XUNIT`. _Mặc định_: `DEFAULT`.                                                                                                                                                                                                                                                                                                                                      |
| `testTimeout`   | **Int**. Thời gian bị time out của 1 test case (Có thể không hoạt động cho 1 vài trường hợp). Nếu giá trị <= 0 thì `testTimeout` không hoạt động>. _Mặc định_: `60`.                                                                                                                                                                                                                                                                                                                                                                                                                                |
| `blackBox`      | **Boolean**. Chỉ ra thực hiện chế độ Black-Box Testing. _Default value_: `false`.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `bbSwaggerUrl`  | **String**. Đường dẫn URL của API Specification. Nếu file ở trên máy, đường dẫn bắt đầu với `file://`. _Mặc định_: `""`.                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| `bbTargetUrl`   | **String**. Chỉ ra địa chỉ server được test, ví dụ: `http://localhost:8080`. Nếu không sử dụng tham số này thì địa chỉ server sẽ được lấy ra từ API Specification được chỉ ra bằng tham số `bbSwaggerUrl`. Nếu thực hiện test GraphQL thì tham số này là bắt buộc, http://localhost:8080/graphql . _Ràng buộc_: `URL`. _Mặc định_: `""`.                                                                                                                                                                                                                                                            |
| `ratePerMinute` | **Int**. Dưới hạn số request được thực hiện mỗi phút (tránh trường hợp request quá nhiều gây ra DDOS). Nếu giá trị <= 0 có ý nghĩa tham số này không được sử dụng. Bắt buộc phải chỉ ra khi thực hiện Black-Box Testing. _Mặc định_: `0`.                                                                                                                                                                                                                                                                                                                                                           |
| `header0`       | **String**. Được sử dụng trong trường hợp request yêu cầu **Authentication**. Sử dụng để chỉ ra các trường nào sẽ xuất hiện trong HTTP Header của mỗi request. Định dạng `name:value`, ví dụ: `--header0 "cookie: <token>"`. Nếu có hơn 1 trường trong HTTP Header, sử dụng _header1_ and _header2_. _Ràng buộc_: `regex (.+:.+)\|(^$)`. _Mặc định_: `""`.                                                                                                                                                                                                                                          |
| `header1`       | **String**. Tương tự `header0`. _Ràng buộc_: `regex (.+:.+)\|(^$)`. _Mặc định_: `""`.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| `header2`       | **String**. Tương tự `header0`. _Ràng buộc_: `regex (.+:.+)\|(^$)`. _Mặc định_: `""`.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |

## Định dạng đầu ra

Khuyến khích sử dụng định dạng đầu ra JUNIT4
`--outputFormat JAVA_JUNIT_4` hoặc JUNIT5 `--outputFormat JAVA_JUNIT_5`

Sau khi thực hiện test, sẽ trả về 2 file nằm trong thư mục kết quả được chỉ định bằng tham số `outputFolder`. Nếu API không có lỗi sẽ trả về 2 file `EvoMaster_successes_Test.java`, `EvoMaster_Test.java`; ngược lại sẽ trả về 2 file `EvoMaster_others_Test.java` và `EvoMaster_Test.java`

Ví dụ:

```
public class EvoMasterTest {

    private static String baseUrlOfSut = "https://api.apis.guru";

    @BeforeClass
    public static void initClass() {
        RestAssured.enableLoggingOfRequestAndResponseIfValidationFails();
        RestAssured.useRelaxedHTTPSValidation();
        RestAssured.urlEncodingEnabled = false;
        RestAssured.config = RestAssured.config()
            .jsonConfig(JsonConfig.jsonConfig().numberReturnType(JsonPathConfig.NumberReturnType.DOUBLE))
            .redirect(redirectConfig().followRedirects(false));
    }


    @Test
    public void test_0() throws Exception {

        given().accept("application/json")
                .get(baseUrlOfSut + "/v2/list.json")
                .then()
                .statusCode(200)
                .assertThat()
                .contentType("application/json")
                .body("size()", numberMatches(1605));
    }


    @Test
    public void test_1() throws Exception {

        given().accept("application/json")
                .get(baseUrlOfSut + "/v2/metrics.json")
                .then()
                .statusCode(200)
                .assertThat()
                .contentType("application/json")
                .body("'numAPIs'", numberMatches(1605.0))
                .body("'numEndpoints'", numberMatches(46276.0))
                .body("'numSpecs'", numberMatches(2869.0));
    }
}
```
