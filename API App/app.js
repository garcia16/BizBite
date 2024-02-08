const express = require('express');
const mysql = require('mysql2/promise');

const app = express();
const port = 8080;

// Middleware para parsear el cuerpo JSON
app.use(express.json());

// Crear el pool de conexiones
const pool = mysql.createPool({
    host: '......',
    user: '......',
    password: '......',
    database: '........',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

app.use((req, res, next) => {
    req.pool = pool;
    next();
});


app.listen(port, () => {
    console.log(`Server corriendo en http://localhost:${port}`);
});

const userRoutes = require('./routes/users');
const companyRoutes = require('./routes/companies');
const productsRoutes = require('./routes/products');
const salesRoutes = require('./routes/sales');

// Otros códigos de configuración...

app.use('/usuarios', userRoutes);
app.use('/empresas', companyRoutes);
app.use('/products', productsRoutes);
app.use('/sales', salesRoutes);




// Manejo de errores 404 - Ruta no encontrada
app.use((req, res) => {
    res.status(404).send('Ruta no encontrada');
});

// Manejo de errores generales
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).send('¡Algo salió mal!');
});

process.on('uncaughtException', (err) => {
    console.error('Excepción no capturada:', err);
    process.exit(1); // Cerrar el servidor de manera controlada
});
