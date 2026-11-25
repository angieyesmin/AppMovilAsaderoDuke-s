import { pool } from "../config/database";
import bcrypt = require("bcryptjs");
import jwt = require("jsonwebtoken");

interface Usuario {
    id_usuario: number;
    nombre_usuario: string;
    nombre_completo: string;
    correo: string | null;
    telefono: string | null;
    password_hash: string;
    rol: string;
    estado: string;
}

// ==========================================
// REGISTRAR USUARIO
// ==========================================

export const registrarUsuario = async (
    nombreCompleto: string,
    nombreUsuario: string,
    correo: string,
    password: string,
    telefono?: string
) => {

    const nombreLimpio = nombreCompleto.trim();
    const usuarioLimpio = nombreUsuario.trim();
    const correoLimpio = correo.trim().toLowerCase();

    if (!nombreLimpio || !usuarioLimpio || !correoLimpio) {
        throw new Error("Completa los campos obligatorios.");
    }

    if (typeof password !== "string" || password.length < 8) {
        throw new Error(
            "La contraseña debe tener al menos 8 caracteres."
        );
    }

    const passwordHash = await bcrypt.hash(password, 10);

    try {

        const resultado = await pool.query(
            `INSERT INTO usuarios (
                nombre_usuario,
                nombre_completo,
                correo,
                password_hash,
                telefono,
                rol,
                estado
            )
            VALUES ($1, $2, $3, $4, $5, 'Cliente', 'Activo')
            RETURNING
                id_usuario,
                nombre_usuario,
                nombre_completo,
                correo,
                telefono,
                rol,
                estado`,
            [
                usuarioLimpio,
                nombreLimpio,
                correoLimpio,
                passwordHash,
                telefono?.trim() || null
            ]
        );

        return resultado.rows[0];

    } catch (error: any) {

        if (error.code === "23505") {
            throw new Error(
                "El correo o nombre de usuario ya está registrado."
            );
        }

        throw error;
    }
};

// ==========================================
// INICIAR SESIÓN
// ==========================================

export const iniciarSesion = async (
    identificador: string,
    password: string
) => {

    const resultado = await pool.query<Usuario>(
        `SELECT
            id_usuario,
            nombre_usuario,
            nombre_completo,
            correo,
            telefono,
            password_hash,
            rol,
            estado
        FROM usuarios
        WHERE LOWER(correo) = LOWER($1)
           OR LOWER(nombre_usuario) = LOWER($1)
        LIMIT 1`,
        [identificador.trim()]
    );

    if (resultado.rows.length === 0) {
        throw new Error(
            "Usuario o contraseña incorrectos."
        );
    }

    const usuario = resultado.rows[0];

    const passwordValida = await bcrypt.compare(
        password,
        usuario.password_hash
    );

    if (!passwordValida) {
        throw new Error(
            "Usuario o contraseña incorrectos."
        );
    }

    if (usuario.estado !== "Activo") {
        throw new Error("Tu cuenta está inactiva.");
    }

    const secret = process.env.JWT_SECRET;

    if (!secret) {
        throw new Error(
            "No está configurada la clave JWT."
        );
    }

    const token = jwt.sign(
        {
            id_usuario: usuario.id_usuario,
            nombre_usuario: usuario.nombre_usuario,
            rol: usuario.rol
        },
        secret,
        {
            expiresIn: "1d"
        }
    );

    const { password_hash, ...datosUsuario } = usuario;

    return {
        token,
        usuario: datosUsuario
    };
};

// ==========================================
// OBTENER PERFIL DEL USUARIO
// ==========================================

export const obtenerPerfil = async (
    idUsuario: number
) => {

    const resultado = await pool.query(
        `SELECT
            id_usuario,
            nombre_usuario,
            nombre_completo,
            correo,
            telefono,
            rol,
            estado,
            fecha_creacion
        FROM public.usuarios
        WHERE id_usuario = $1
          AND estado = 'Activo'`,
        [idUsuario]
    );

    return resultado.rows[0] ?? null;
};