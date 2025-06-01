const redis = require('redis');

const client = redis.createClient({
    socket: {
        host: 'rediss',
        port: 6379
    },
    legacyMode: true
});

client.on('connect', async () => {
    console.log("Redis connection success")
})

client.on('error', err => {
    console.log('Error ' + err);
});

client.connect().then();
redisClient = client.v4