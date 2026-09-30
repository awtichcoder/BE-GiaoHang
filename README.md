# DeliveryPlatform - Backend basic

## Phân công
- Nhóm 1: Identity — tài khoản, OTP, địa chỉ, ngân hàng, quyền.
- Nhóm 2: Delivery + Dispatch — đơn, báo giá, checkout; hồ sơ Shipper, matching, tracking.
- Nhóm 3: Finance + Reporting (Admin & Reporting) — thanh toán, ví, COD, công nợ; báo cáo và export.
- Nhóm 4: Communication — email, thông báo, chat, media.

API Admin thuộc service sở hữu nghiệp vụ, không gom hết vào Reporting.

## Thư mục mỗi project
Controllers nhận request; Services xử lý nghiệp vụ; Models là entity; DTOs là request/response; Data chứa DbContext; Clients chứa HttpClient.
Migrations sẽ được EF Core tạo sau khi có model.

## Chạy
Nếu đã cài Yarn, chạy `yarn dev` tại thư mục gốc để bật cả 6 API. Không cần `yarn install` vì package.json chỉ chứa lệnh tắt, không có dependency Node.js. Ctrl+C để dừng.

Trong Git Bash, dùng lệnh ngắn `./start.sh` (Ctrl+C để dừng). Kiểm tra rồi tự dừng: `./start.sh -CheckOnly`.

Một lệnh chạy cả 6 service trong terminal Git Bash hoặc PowerShell tại thư mục gốc:

```shell
powershell -NoProfile -ExecutionPolicy Bypass -File ./start-all.ps1
```

Nhấn Ctrl+C để dừng trước khi đóng terminal. Log nằm trong `.local-logs`. Script không tắt ứng dụng khác nếu cổng đã bị chiếm. Thêm `-CheckOnly` để kiểm tra rồi tự dừng. Bypass chỉ áp dụng cho tiến trình này, không đổi chính sách máy.

Chạy `dotnet build DeliveryPlatform.sln`.
VS Code: Terminal > Run Task > Run Identity hoặc Run all APIs.
Terminal > Terminate Task để dừng.

- Identity: http://localhost:5001/api/health
- Delivery: http://localhost:5002/api/health
- Dispatch: http://localhost:5003/api/health
- Finance: http://localhost:5004/api/health
- Reporting: http://localhost:5005/api/health
- Communication: http://localhost:5006/api/health

## Giới hạn
Đây chỉ là cấu trúc và API health, chưa có nghiệp vụ, kết nối SQL, xác thực, thanh toán hay giao tiếp giữa service. Health không kiểm tra database.
Theo trao đổi basic, chưa thêm RabbitMQ, Gateway, outbox hoặc kiểm thử nghiệp vụ. Các yêu cầu này trong tài liệu cần triển khai sau.
Giữ lại các file WeatherForecast từ template. Chưa sẵn sàng production.
Mỗi service sở hữu database riêng; không truy cập database của nhau. Dùng User Secrets cho mật khẩu local, không commit khóa vào Git.

