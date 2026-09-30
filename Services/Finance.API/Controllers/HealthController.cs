using Microsoft.AspNetCore.Mvc;
namespace Finance.API.Controllers;
[ApiController]
[Route("api/health")]
public class HealthController : ControllerBase
{
    [HttpGet]
    public IActionResult Get() => Ok(new { service = "Finance", status = "Running" });
}

