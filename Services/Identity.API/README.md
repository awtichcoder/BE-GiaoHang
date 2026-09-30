# Identity.API

Phạm vi: Auth, Profiles, Addresses, BankAccounts, Roles.

Chạy từ thư mục gốc:

```shell
dotnet run --project Services/Identity.API --no-launch-profile --urls http://localhost:5001
```

Kiểm tra: http://localhost:5001/api/health
Health chỉ xác nhận API chạy, không kiểm tra SQL Server hoặc nghiệp vụ.
Database dự kiến: IdentityDb. Chưa cấu hình kết nối.

