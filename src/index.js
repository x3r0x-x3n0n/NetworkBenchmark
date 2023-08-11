const express = require('express');
const bodyParser = require('body-parser');
const app = express();

// Use body-parser middleware to parse JSON and URL-encoded request bodies
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.post('/echo', (req, res) => {
  const requestBody = req.body;
  res.json(requestBody);
});

// Get port number from the environment variable or use a default value (e.g., 3000)
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

