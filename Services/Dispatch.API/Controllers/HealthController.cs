using Microsoft.AspNetCore.Mvc;
namespace Dispatch.API.Controllers;
[ApiController]
[Route("api/health")]
public class HealthController : ControllerBase
{
    [HttpGet]
    public IActionResult Get() => Ok(new { service = "Dispatch", status = "Running" });
}

