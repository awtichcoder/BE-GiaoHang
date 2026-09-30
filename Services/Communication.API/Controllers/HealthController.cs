using Microsoft.AspNetCore.Mvc;
namespace Communication.API.Controllers;
[ApiController]
[Route("api/health")]
public class HealthController : ControllerBase
{
    [HttpGet]
    public IActionResult Get() => Ok(new { service = "Communication", status = "Running" });
}

