// Minimal server for PWA - Frontend only (no backend API)
import express from "express";
import { setupVite, serveStatic, log } from "./vite";
import { createServer } from "http";

const app = express();

(async () => {
  const server = createServer(app);

  // Setup Vite dev server in development, static file serving in production
  if (app.get("env") === "development") {
    await setupVite(app, server);
  } else {
    serveStatic(app);
  }

  // Serve on port 5000 (Replit requirement)
  const port = parseInt(process.env.PORT || '5000', 10);
  server.listen(port, '0.0.0.0', () => {
    log(`PWA dev server running on port ${port}`);
  });
})();
