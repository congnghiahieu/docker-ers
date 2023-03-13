# Schemathesis enviroment variables

Refer: [Schemathesis command options](/docker-ers-single/docs/Schemathesis.md)

Biến môi trường nằm dùng cho Schemathesis luôn có prefix `S_`:

| Options                    | Environment variables                      |
| -------------------------- | ------------------------------------------ |
| `S_WORKER`                 | `--workers / -w` (**required**)            |
| `S_CHECKS`                 | `--checks / -c` (**required**)             |
| `S_TESTCASE_PER_OPERATION` | `--hypothesis-max-examples` (**required**) |
| `S_BASE_URL`               | `--base-url` (**required**)                |
