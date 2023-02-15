const mysql = require('mysql2/promise')

const db = async () => {
    try {
        const connection = await mysql.createConnection({
            host: 'sqll',
            port: '3306',
            password: 'hoplin1234!',
            database: 'mysql',
            user: 'root'
        })

        const [result, _] = await connection.query('SELECT 1 + 1')
        console.log(result)
    } catch (err) {
        console.error(err)
    }
}

db()