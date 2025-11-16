// The North - Ravens Messaging Service
// Backend API for sending messages between kingdoms

const express = require('express');
const cors = require('cors');
const { createClient } = require('redis');
const { Server } = require('socket.io');
const http = require('http');

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"]
  }
});

const PORT = process.env.PORT || 3000;
const REDIS_HOST = process.env.REDIS_HOST || 'redis-service';
const REDIS_PORT = process.env.REDIS_PORT || 6379;

app.use(cors());
app.use(express.json());

// Redis client
let redisClient;

async function initRedis() {
  redisClient = createClient({
    socket: {
      host: REDIS_HOST,
      port: REDIS_PORT
    }
  });

  redisClient.on('error', (err) => console.error('Redis Client Error', err));
  await redisClient.connect();
  console.log('Connected to Redis');
}

// Health check
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    service: 'The North - Ravens Service',
    motto: 'Winter is Coming'
  });
});

// Get all ravens (messages)
app.get('/api/ravens', async (req, res) => {
  try {
    const ravens = await redisClient.lRange('ravens', 0, -1);
    const messages = ravens.map(r => JSON.parse(r));
    res.json(messages);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Send a raven (message)
app.post('/api/ravens/send', async (req, res) => {
  try {
    const { from, to, message, priority } = req.body;

    const raven = {
      id: Date.now(),
      from,
      to,
      message,
      priority: priority || 'normal',
      timestamp: new Date().toISOString(),
      delivered: false
    };

    await redisClient.rPush('ravens', JSON.stringify(raven));

    // Emit to all connected clients
    io.emit('new-raven', raven);

    res.status(201).json({
      success: true,
      message: 'Raven sent successfully',
      raven
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Mark raven as delivered
app.put('/api/ravens/:id/deliver', async (req, res) => {
  try {
    const { id } = req.params;
    const ravens = await redisClient.lRange('ravens', 0, -1);

    const updatedRavens = ravens.map(r => {
      const raven = JSON.parse(r);
      if (raven.id == id) {
        raven.delivered = true;
      }
      return JSON.stringify(raven);
    });

    await redisClient.del('ravens');
    for (const raven of updatedRavens) {
      await redisClient.rPush('ravens', raven);
    }

    res.json({ success: true, message: 'Raven delivered' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get kingdoms statistics
app.get('/api/stats', async (req, res) => {
  try {
    const ravens = await redisClient.lRange('ravens', 0, -1);
    const messages = ravens.map(r => JSON.parse(r));

    const stats = {
      totalRavens: messages.length,
      delivered: messages.filter(r => r.delivered).length,
      pending: messages.filter(r => !r.delivered).length,
      byKingdom: {}
    };

    messages.forEach(r => {
      stats.byKingdom[r.from] = (stats.byKingdom[r.from] || 0) + 1;
    });

    res.json(stats);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// WebSocket connection
io.on('connection', (socket) => {
  console.log('A kingdom connected:', socket.id);

  socket.on('disconnect', () => {
    console.log('Kingdom disconnected:', socket.id);
  });

  socket.on('send-raven', async (data) => {
    const raven = {
      id: Date.now(),
      ...data,
      timestamp: new Date().toISOString(),
      delivered: false
    };

    await redisClient.rPush('ravens', JSON.stringify(raven));
    io.emit('new-raven', raven);
  });
});

// Start server
async function start() {
  try {
    await initRedis();
    server.listen(PORT, '0.0.0.0', () => {
      console.log(`🐦 The North Ravens Service running on port ${PORT}`);
      console.log(`⚔️  Winter is Coming...`);
    });
  } catch (error) {
    console.error('Failed to start server:', error);
    process.exit(1);
  }
}

start();
