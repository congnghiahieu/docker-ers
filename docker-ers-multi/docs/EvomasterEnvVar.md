# Evomaster enviroment variables

Refer: [Evomaster command options](/docker-ers-single/docs/Evomaster.md)

Biến môi trường nằm dùng cho Evomaster luôn có prefix `E_`:

| Options         | Environment variables              |
| --------------- | ---------------------------------- |
| `problemType`   | `E_PROBLEM_TYPE`                   |
| `outputFolder`  |                                    |
| `maxTime`       | `E_MAX_TIME` (**required**)        |
| `outputFormat`  | `E_OUTPUT_FORMAT` (**required**)   |
| `testTimeout`   | `E_TIMEOUT`                        |
| `bbSwaggerUrl`  | `API_SPEC_URL` (**required**)      |
| `bbTargetUrl`   |                                    |
| `ratePerMinute` | `E_RATE_PER_MINUTE` (**required**) |
| `header0`       |                                    |
| `header1`       |                                    |
| `header2`       |                                    |
