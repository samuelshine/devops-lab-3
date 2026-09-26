import express from 'express';

const app = express();
const PORT = process.env.PORT || 3000;
const VERSION = process.env.APP_VERSION || 'dev';

app.get('/', (req, res) => {
  res.json({ app: 'devops-lab-3', version: VERSION, message: 'Hello from an OCI container' });
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok', uptime: process.uptime() });
});

app.listen(PORT, () => {
  console.log(`devops-lab-3 v${VERSION} listening on port ${PORT}`);
});
