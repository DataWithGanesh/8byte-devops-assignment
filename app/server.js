const express = require("express");
const client = require("prom-client");

const app = express();

const PORT = process.env.PORT || 3000;

const register = new client.Registry();

client.collectDefaultMetrics({
  register,
});

// Request Counter
const httpRequestsTotal = new client.Counter({
  name: "http_requests_total",
  help: "Total number of HTTP requests",
  labelNames: ["method", "route", "status"],
});

// Error Counter
const httpErrorsTotal = new client.Counter({
  name: "http_errors_total",
  help: "Total number of HTTP errors",
  labelNames: ["method", "route", "status"],
});

// Latency Histogram
const httpRequestDuration = new client.Histogram({
  name: "http_request_duration_seconds",
  help: "HTTP request duration in seconds",
  labelNames: ["method", "route"],
  buckets: [0.1, 0.3, 0.5, 1, 2, 5],
});

register.registerMetric(httpRequestsTotal);
register.registerMetric(httpErrorsTotal);
register.registerMetric(httpRequestDuration);

// Metrics Middleware
app.use((req, res, next) => {
  const end = httpRequestDuration.startTimer();

  res.on("finish", () => {
    httpRequestsTotal.inc({
      method: req.method,
      route: req.path,
      status: res.statusCode,
    });

    if (res.statusCode >= 400) {
      httpErrorsTotal.inc({
        method: req.method,
        route: req.path,
        status: res.statusCode,
      });
    }

    end({
      method: req.method,
      route: req.path,
    });
  });

  next();
});

app.get("/", (req, res) => {
  res.json({
    message: "8Byte DevOps Assignment",
    status: "success",
  });
});

app.get("/health", (req, res) => {
  res.status(200).json({
    status: "healthy",
  });
});

// Test error endpoint
app.get("/error", (req, res) => {
  res.status(500).json({
    status: "error",
  });
});

app.get("/metrics", async (req, res) => {
  res.set("Content-Type", register.contentType);
  res.end(await register.metrics());
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
