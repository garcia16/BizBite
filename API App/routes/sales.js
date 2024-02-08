const express = require('express');
const router = express.Router();
const moment = require('moment');

// Método GET para obtener la lista de ventas con detalles de productos
router.get('/:id', async (req, res) => {
    try {
        const companyID = req.params.id;
        const fields = req.query.fields; 

        let selectFields = fields ? fields.split(',').join(', ') : '*'; 

        const sql = `SELECT ${selectFields}, B.idProduct, B.quantityProduct, B.priceProduct, C.nameProduct FROM SALES_TABLE A 
                     JOIN SALES_DETAIL_TABLE B 
                     ON A.IDCOMPANY = B.IDCOMPANY AND A.IDSALE = B.IDSALE 
                     JOIN PRODUCTS_TABLE C 
                     ON B.idProduct = C.idProduct
                     WHERE A.idCompany = ?`;

        const [rows] = await req.pool.query(sql, [companyID]);

        const sales = {};
        rows.forEach(row => {
            if (!sales[row.idSale]) {
                sales[row.idSale] = {
                    idCompany: row.idCompany,
                    idSale: row.idSale,
                    idUser: row.idUser,
                    amountSale: row.amountSale,
                    dateSale: row.dateSale,
                    photoSale: row.photoSale,
                    products: []
                };
            }
            sales[row.idSale].products.push({
                idProduct: row.idProduct,
                quantityProduct: row.quantityProduct,
                priceProduct: row.priceProduct,
                nameProduct: row.nameProduct
            });
        });

        res.send(Object.values(sales));
    } catch (err) {
        console.error(err);
        res.status(500).send('Error al consultar la base de datos.');
    }
});

// Método POST para añadir una nueva venta de forma manual
router.post('/addManualSale', async (req, res) => {
    let connection;  // Declarar la variable connection aquí para que esté en el ámbito correcto

    try {
        const { idCompany, idSale, idUser, amountSale, dateSale, photoSale, products } = req.body;
        connection = await req.pool.getConnection();  // Asignar el valor a connection
        await connection.beginTransaction();

        let dateSaleRestore = moment(dateSale, 'DD-MM-YYYY – HH:mm:ss').format('YYYY-MM-DD HH:mm:ss');

        const sqlSale = `INSERT INTO SALES_TABLE (idCompany, idSale, idUser, amountSale, dateSale, photoSale) VALUES (?, ?, ?, ?, ?, ?)`;
        await connection.query(sqlSale, [idCompany, idSale, idUser, amountSale, dateSaleRestore, photoSale]);

        const sqlProduct = `INSERT INTO SALES_DETAIL_TABLE (idCompany, idSale, idUser, idProduct, quantityProduct, priceProduct) VALUES ?`;
        const productValues = products.map(p => [idCompany, idSale, idUser, p.idProduct, p.quantityProduct, p.priceProduct]);  // Asegúrate de que es p.priceProduct y no p.amountProduct

        await connection.query(sqlProduct, [productValues]);
        await connection.commit();

        connection.release();  // Libera la conexión al final del bloque try
        res.send('Venta añadida con éxito.');
    } catch (err) {
        if (connection) {
            await connection.rollback();  // Ahora connection está definida y puede ser usada aquí
            connection.release();
        }
        console.error(err);
        res.status(500).send('Error al procesar la venta.');
    }
});

// Método POST para añadir una nueva venta escaneada
router.post('/addScanSale', async (req, res) => {
    let connection;  // Declarar la variable connection aquí para que esté en el ámbito correcto

    try {
        const { idCompany, idSale, idUser, amountSale, dateSale, photoSale } = req.body;
        connection = await req.pool.getConnection();  // Asignar el valor a connection
        await connection.beginTransaction();

        let dateSaleRestore = moment(dateSale, 'DD-MM-YYYY – HH:mm:ss').format('YYYY-MM-DD HH:mm:ss');

        const sqlSale = `INSERT INTO SALES_TABLE (idCompany, idSale, idUser, amountSale, dateSale, photoSale) VALUES (?, ?, ?, ?, ?, ?)`;
        await connection.query(sqlSale, [idCompany, idSale, idUser, amountSale, dateSaleRestore, photoSale]);
        await connection.commit();

        connection.release();  // Libera la conexión al final del bloque try
        res.send('Venta añadida con éxito.');
    } catch (err) {
        if (connection) {
            await connection.rollback();  // Ahora connection está definida y puede ser usada aquí
            connection.release();
        }
        console.error(err);
        res.status(500).send('Error al procesar la venta.');
    }
});


module.exports = router;
