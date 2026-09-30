using Microsoft.AspNetCore.Mvc;
namespace Reporting.API.Controllers;
[ApiController]
[Route("api/health")]
public class HealthController : ControllerBase
{
    [HttpGet]
    public IActionResult Get() => Ok(new { service = "Reporting", status = "Running" });
}

