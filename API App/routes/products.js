const express = require('express');
const router = express.Router();

// MÉTODO GET PARA OBTENER LA LISTA DE PRODUCTOS
router.get('/:id', async (req, res) => {
    try {
        const companyID = req.params.id;
        const fields = req.query.fields; 

        let selectFields = fields ? fields.split(',').join(', ') : '*'; 

        const sql = `SELECT ${selectFields} FROM PRODUCTS_TABLE WHERE idCompany = ?`;

        const [rows] = await req.pool.query(sql, [companyID]);
        res.send(rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Error al consultar la base de datos.');
    }
});

// MÉTODO GET PARA OBTENER LA LISTA DE CATEGORIAS DE PRODUCTOS
router.get('/category-products/:id', async (req, res) => {
    try {
        const companyID = req.params.id;
        const fields = req.query.fields; 

        let selectFields = fields ? fields.split(',').join(', ') : '*'; 

        const sql = `SELECT ${selectFields} FROM CATEGORY_PRODUCTS_TABLE WHERE idCompany = ? ORDER BY CATEGORYPRODUCT ASC`;

        const [rows] = await req.pool.query(sql, [companyID]);
        res.send(rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Error al consultar la base de datos.');
    }
});

// MÉTODO POST PARA INSERTAR UN NUEVO PRODUCTO
router.post('/', async (req, res) => {
    try {
        const productData = req.body;
        const keys = Object.keys(productData);
        const values = Object.values(productData);

        const columns = keys.join(', ');
        const placeholders = keys.map(() => '?').join(', ');

        const sql = `INSERT INTO PRODUCTS_TABLE (${columns}) VALUES (${placeholders})`;

        const [result] = await req.pool.query(sql, values);
        res.status(201).send({ id: result.insertId, ...productData });
    } catch (err) {
        console.error(err);
        res.status(500).send('Error al insertar en la base de datos.');
    }
});

// MÉTODO POST PARA INSERTAR UNA NUEVA CATEGORIA DE PRODUCTO
router.post('/addCategory', async (req, res) => {
    try {
        const productData = req.body;
        const keys = Object.keys(productData);
        const values = Object.values(productData);

        const columns = keys.join(', ');
        const placeholders = keys.map(() => '?').join(', ');

        const sql = `INSERT INTO CATEGORY_PRODUCTS_TABLE (${columns}) VALUES (${placeholders})`;

        const [result] = await req.pool.query(sql, values);
        res.status(201).send({ id: result.insertId, ...productData });
    } catch (err) {
        console.error(err);
        res.status(500).send('Error al insertar en la base de datos.');
    }
});

// Método PUT para actualizar el stock de varios productos
router.put('/update-stock', async (req, res) => {
    try {
        const productsToUpdate = req.body;

        if (!Array.isArray(productsToUpdate)) {
            return res.status(400).send('Se requiere una lista de productos.');
        }

        for (let product of productsToUpdate) {
            const sql = `UPDATE PRODUCTS_TABLE SET STOCKPRODUCT = ? WHERE idCompany = ? AND idProduct = ?`;
            await req.pool.query(sql, [product.stockProduct, product.idCompany, product.idProduct]);
        }

        res.send('Stocks actualizados con éxito.');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error al actualizar los stocks.');
    }
});

// Método PUT para actualizar los datos de un producto
router.put('/update-product', async (req, res) => {
    try {
        const {
            idCompany,
            idProduct,
            nameProduct,
            categoryProduct,
            stockProduct,
            priceProduct,
            salePriceProduct,
            distributorProduct,
            referenceProduct,
            notesProduct,
            photoProduct
        } = req.body; 

        const sql = `
            UPDATE PRODUCTS_TABLE
            SET 
                nameProduct = ?, 
                categoryProduct = ?, 
                stockProduct = ?, 
                priceProduct = ?, 
                salePriceProduct = ?, 
                distributorProduct = ?, 
                referenceProduct = ?, 
                notesProduct = ?, 
                photoProduct = ?
            WHERE idCompany = ? AND idProduct = ?`;

        await req.pool.query(sql, [
            nameProduct, 
            categoryProduct, 
            stockProduct, 
            priceProduct, 
            salePriceProduct, 
            distributorProduct, 
            referenceProduct, 
            notesProduct, 
            photoProduct, 
            idCompany, 
            idProduct
        ]);

        res.send('Producto actualizado con éxito.');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error al actualizar los datos del producto.');
    }
});

// Método PUT para actualizar los datos de una categoría
router.put('/update-category', async (req, res) => {
    try {
        const {
            idCompany,
            categoryProduct,
            nameCategory,
            updateProducts,
            originalNameCategory
        } = req.body; 

        const sql = `
            UPDATE CATEGORY_PRODUCTS_TABLE
            SET 
                nameCategory = ? 
            WHERE idCompany = ? AND categoryProduct = ?`;

        await req.pool.query(sql, [
            nameCategory, 
            idCompany, 
            categoryProduct, 
        ]);

        // Si updateProducts es true, actualizamos todos los productos que tengan esa categoria
        if(updateProducts) {
            const sqlUpdateProducts = `
                UPDATE PRODUCTS_TABLE
                SET 
                    categoryProduct = ?
                WHERE idCompany = ? AND categoryProduct = ?`;
            await req.pool.query(sqlUpdateProducts, [
                nameCategory, 
                idCompany, 
                originalNameCategory, 
            ]);
        }

        res.send('Categoria actualizada con éxito.');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error al actualizar los datos de la categoría.');
    }
});

// Método DELETE para eliminar los datos de una categoría
router.delete('/delete-category', async (req, res) => {
    try {
        const {
            idCompany,
            categoryProduct,
            updateProducts,
        } = req.body; 

        const sqlDeleteCategory = `
            DELETE FROM CATEGORY_PRODUCTS_TABLE
            WHERE idCompany = ? AND categoryProduct = ?`;

        await req.pool.query(sqlDeleteCategory, [
            idCompany, 
            categoryProduct,
        ]);

        if(updateProducts) {
            const categoryDefault = 'Sin categoría';

            const sqlDeleteProducts = `
            UPDATE PRODUCTS_TABLE
            SET 
                categoryProduct = ?
            WHERE idCompany = ? AND categoryProduct = ?`;
            await req.pool.query(sqlDeleteProducts, [
                categoryDefault, 
                idCompany,
                categoryProduct 
            ]);
        }

        res.send('Categoría eliminada con éxito.');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error al eliminar la categoría.');
    }
});


module.exports = router;
