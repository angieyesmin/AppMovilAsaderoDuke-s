"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.probarConexion = exports.pool = void 0;
require("dotenv/config");
const pg_1 = require("pg");
exports.pool = new pg_1.Pool({
    host: process.env.PGHOST,
    port: Number(process.env.PGPORT || 5432),
    database: process.env.PGDATABASE,
    user: process.env.PGUSER,
    password: process.env.PGPASSWORD,
    max: 10,
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 5000
});
// Comprobar errores de conexión
exports.pool.on("error", (error) => {
    console.error("Error inesperado en PostgreSQL:", error);
});
// Probar conexión
const probarConexion = async () => {
    try {
        const resultado = await exports.pool.query("SELECT NOW()");
        console.log("==================================");
        console.log(" CONEXIÓN A POSTGRESQL EXITOSA");
        console.log(" Fecha:", resultado.rows[0].now);
        console.log("==================================");
    }
    catch (error) {
        console.error("Error al conectar con PostgreSQL:", error);
        throw error;
    }
};
exports.probarConexion = probarConexion;
