const express = require('express');
const router = express.Router();

// MÉTODO GET PARA OBTENER DATOS DEL USUARIO
router.get('/:id', async (req, res) => {
    try {
        const userId = req.params.id;
        const fields = req.query.fields; 

        let selectFields = fields ? fields.split(',').join(', ') : '*'; 
        const sql = `SELECT ${selectFields} FROM USER_TABLE WHERE idUser = ?`;

        const [rows] = await req.pool.query(sql, [userId]);
        res.send(rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).send('Error al consultar la base de datos.');
    }
});

// MÉTODO PATCH PARA ACTUALIZAR DATOS DEL USUARIO
router.patch('/:id', async (req, res) => {
    try {
        const userId = req.params.id;
        const updates = req.body;

        let updateQueries = [];
        let values = [];
        for (let key in updates) {
            updateQueries.push(`${key} = ?`);
            values.push(updates[key]);
        }
        values.push(userId); 

        const sql = `UPDATE USER_TABLE SET ${updateQueries.join(', ')} WHERE idUser = ?`;

        const [result] = await req.pool.query(sql, values);
        res.send(result);
    } catch (err) {
        console.error(err);
        res.status(500).send('Error al actualizar en la base de datos.');
    }
});

// MÉTODO POST PARA INSERTAR UN NUEVO USUARIO
router.post('/', async (req, res) => {
    try {
        const userData = req.body;
        const keys = Object.keys(userData);
        const values = Object.values(userData);

        const columns = keys.join(', ');
        const placeholders = keys.map(() => '?').join(', ');

        const sql = `INSERT INTO USER_TABLE (${columns}) VALUES (${placeholders})`;

        const [result] = await req.pool.query(sql, values);
        res.send(result);
    } catch (err) {
        console.error(err);
        res.status(500).send('Error al insertar en la base de datos.');
    }
});

// MÉTODO DELETE PARA ELIMINAR UN USUARIO
router.delete('/:id', async (req, res) => {
    try {
        const userId = req.params.id;
        const sql = 'DELETE FROM USER_TABLE WHERE idUser = ?';

        const [result] = await req.pool.query(sql, [userId]);
        res.send(result);
    } catch (err) {
        console.error(err);
        res.status(500).send('Error al eliminar de la base de datos.');
    }
});

module.exports = router;
