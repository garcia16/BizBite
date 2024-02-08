const express = require('express');
const router = express.Router();
const moment = require('moment');

// MÉTODO GET PARA OBTENER DATOS DE LA EMPRESA
router.get('/:id', async (req, res) => {
    try {
        const companyID = req.params.id;
        const fields = req.query.fields; 

        //let selectFields = fields ? fields.split(',').join(', ') : '*'; 

        const sql = `SELECT A.IDCOMPANY as idCompany, A.NAMECOMPANY as nameCompany, A.NIFCOMPANY as nifCompany, A.CATEGORYCOMPANY as categoryCompany, A.PHOTOCOMPANY as photoCompany,
        A.COUNTRYCOMPANY as countryCompany, A.EMPLOYEESCOMPANY as employeesCompany, A.ADMINCOMPANY as adminCompany, A.STATUSCOMPANY as statusCompany,
        B.UIDUSER as uidAdminCompany
        FROM COMPANY_TABLE A, USER_TABLE B WHERE B.IDUSER = A.ADMINCOMPANY AND idCompany = ?`;

        const [rows] = await req.pool.query(sql, [companyID]);
        res.send(rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).send('Error al consultar la base de datos.');
    }
});

// MÉTODO GET PARA OBTENER DATOS DE LOS USUARIOS DE LA EMPRESA
router.get('/users-company/:id', async (req, res) => {
    try {
        const companyID = req.params.id;

        const sql = `SELECT CONCAT(A.NAMEUSER, ' ', A.LASTNAMEUSER) AS name,A.UIDUSER AS uidUser, A.IDUSER AS idUser, B.ROLUSER AS position, A.PHOTOUSER AS imagepath
        FROM USER_TABLE A, USER_COMPANY_TABLE B
        WHERE A.IDUSER = B.IDUSER
        AND B.IDCOMPANY = ?`;

        const [rows] = await req.pool.query(sql, [companyID]);
        res.send(rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Error al consultar la base de datos.');
    }
});

// MÉTODO GET PARA OBTENER DATOS DE LOS USUARIOS DE LA EMPRESA
router.get('/reports/:id', async (req, res) => {
    try {
        const companyID = req.params.id;

        const sql = `SELECT idCompany, idReport, dateReport, annualReport, detailReport, typeReport, urlReport
        FROM REPORTS_TABLE WHERE IDCOMPANY = ? ORDER BY idReport ASC`;

        const [rows] = await req.pool.query(sql, [companyID]);
        res.send(rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Error al consultar la base de datos.');
    }
});


// MÉTODO PATCH PARA ACTUALIZAR DATOS DE LA EMPRESA
router.patch('/:id', async (req, res) => {
    try {
        const companyID = req.params.id;
        const updates = req.body;

        let updateQueries = [];
        let values = [];
        for (let key in updates) {
            updateQueries.push(`${key} = ?`);
            values.push(updates[key]);
        }
        values.push(companyID); 

        const sql = `UPDATE COMPANY_TABLE SET ${updateQueries.join(', ')} WHERE idCompany = ?`;

        const [result] = await req.pool.query(sql, values);
        res.send(result);
    } catch (err) {
        console.error(err);
        res.status(500).send('Error al actualizar en la base de datos.');
    }
});

// MÉTODO POST PARA INSERTAR UNA NUEVA EMPRESA
router.post('/', async (req, res) => {
    try {
        const companyData = req.body;
        const keys = Object.keys(companyData);
        const values = Object.values(companyData);

        const columns = keys.join(', ');
        const placeholders = keys.map(() => '?').join(', ');

        const sql = `INSERT INTO COMPANY_TABLE (${columns}) VALUES (${placeholders})`;

        const [result] = await req.pool.query(sql, values);
        res.send(result);
    } catch (err) {
        console.error(err);
        res.status(500).send('Error al insertar en la base de datos.');
    }
});

// Método POST para añadir un nuevo Informe a la base de datos
router.post('/addNewReport', async (req, res) => {
    let connection;  

    try {
        let { idCompany, idReport, dateReport, isAnnualReport, includesDetail, typeReport, urlReport} = req.body;
        connection = await req.pool.getConnection();  
        await connection.beginTransaction();

        isAnnualReport = isAnnualReport ? 'S' : 'N';
        includesDetail = includesDetail ? 'S' : 'N';

        let dateReportRestore = moment(dateReport, 'DD-MM-YYYY – HH:mm:ss').format('YYYY-MM-DD HH:mm:ss');


        const sqlReport = `INSERT INTO REPORTS_TABLE (idCompany,idReport, dateReport, annualReport, detailReport, typeReport, urlReport) VALUES (?, ?, ?, ?, ?, ?, ?)`;
        await connection.query(sqlReport, [idCompany,idReport, dateReportRestore, isAnnualReport, includesDetail, typeReport, urlReport]);

        await connection.commit();

        connection.release();  
        res.send('Informe añadido con éxito.');
    } catch (err) {
        if (connection) {
            await connection.rollback();  // Ahora connection está definida y puede ser usada aquí
            connection.release();
        }
        console.error(err);
        res.status(500).send('Error al procesar el documento.');
    }
});

// Método PUT para actualizar los datos de roles de los usuarios
router.put('/update-role', async (req, res) => {
    try {
        const {
            idCompany,
            rolUser,
            idUser,
        } = req.body; 

        const sql = `
            UPDATE USER_COMPANY_TABLE
            SET 
                rolUser = ? 
            WHERE idCompany = ? AND idUser = ?`;

        await req.pool.query(sql, [
            rolUser, 
            idCompany, 
            idUser, 
        ]);

        

        res.send('Categoria actualizada con éxito.');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error al actualizar los datos de la categoría.');
    }
});

// Método DELETE para eliminar al usuario de una empresa
router.delete('/delete-user-company', async (req, res) => {
    try {
        const {
            idCompany,
            idUser,
        } = req.body; 

        const sqlDeleteCategory = `
            DELETE FROM USER_COMPANY_TABLE
            WHERE idCompany = ? AND idUser = ?`;

        await req.pool.query(sqlDeleteCategory, [
            idCompany, 
            idUser,
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
