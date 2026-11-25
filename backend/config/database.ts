
import "dotenv/config";
import { Pool } from "pg";

export const pool = new Pool({
    host: process.env.PGHOST,
    port: Number(process.env.PGPORT || 5432),
    database: process.env.PGDATABASE,
    user: process.env.PGUSER,
    password: process.env.PGPASSWORD,
    max: 10,
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 5000
});

// COMPROBAR ERRORES DE CONEXIÓN
pool.on("error", (error) => {
    console.error(
        "Error inesperado en PostgreSQL:",
        error
    );
});

// PROBAR CONEXIÓN
export const probarConexion = async () => {
    try {
        const resultado = await pool.query(`
            SELECT
                NOW() AS fecha,
                current_database() AS base_datos,
                current_schema() AS esquema,
                current_user AS usuario,
                to_regclass('public.usuarios') AS tabla_usuarios
        `);

        const datos = resultado.rows[0];

        console.log("==================================");
        console.log(" CONEXIÓN A POSTGRESQL EXITOSA");
        console.log(" Base de datos:", datos.base_datos);
        console.log(" Esquema:", datos.esquema);
        console.log(" Usuario:", datos.usuario);
        console.log(" Fecha:", datos.fecha);

        if (datos.tabla_usuarios) {
            console.log(" Tabla usuarios: EXISTE");
        } else {
            console.error(" Tabla usuarios: NO EXISTE");
        }

        console.log("==================================");

    } catch (error) {
        console.error(
            "Error al conectar con PostgreSQL:",
            error
        );

        throw error;
    }
};
