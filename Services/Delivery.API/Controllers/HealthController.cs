using Microsoft.AspNetCore.Mvc;
namespace Delivery.API.Controllers;
[ApiController]
[Route("api/health")]
public class HealthController : ControllerBase
{
    [HttpGet]
    public IActionResult Get() => Ok(new { service = "Delivery", status = "Running" });
}

