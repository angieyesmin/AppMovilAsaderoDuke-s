"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.iniciarSesion = exports.registrarUsuario = void 0;
const database_1 = require("../config/database");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
// ==========================================
// REGISTRAR USUARIO
// ==========================================
const registrarUsuario = async (nombreCompleto, nombreUsuario, correo, password, telefono) => {
    const nombreLimpio = nombreCompleto.trim();
    const usuarioLimpio = nombreUsuario.trim();
    const correoLimpio = correo.trim().toLowerCase();
    if (!nombreLimpio || !usuarioLimpio || !correoLimpio) {
        throw new Error("Completa los campos obligatorios.");
    }
    if (typeof password !== "string" || password.length < 8) {
        throw new Error("La contraseña debe tener al menos 8 caracteres.");
    }
    const passwordHash = await bcrypt.hash(password, 10);
    try {
        const resultado = await database_1.pool.query(`INSERT INTO usuarios (
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
                estado`, [
            usuarioLimpio,
            nombreLimpio,
            correoLimpio,
            passwordHash,
            telefono?.trim() || null
        ]);
        return resultado.rows[0];
    }
    catch (error) {
        if (error.code === "23505") {
            throw new Error("El correo o nombre de usuario ya está registrado.");
        }
        throw error;
    }
};
exports.registrarUsuario = registrarUsuario;
// ==========================================
// INICIAR SESIÓN
// ==========================================
const iniciarSesion = async (identificador, password) => {
    const resultado = await database_1.pool.query(`SELECT
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
         LIMIT 1`, [identificador.trim()]);
    if (resultado.rows.length === 0) {
        throw new Error("Usuario o contraseña incorrectos.");
    }
    const usuario = resultado.rows[0];
    const passwordValida = await bcrypt.compare(password, usuario.password_hash);
    if (!passwordValida) {
        throw new Error("Usuario o contraseña incorrectos.");
    }
    if (usuario.estado !== "Activo") {
        throw new Error("Tu cuenta está inactiva.");
    }
    const secret = process.env.JWT_SECRET;
    if (!secret) {
        throw new Error("No está configurada la clave JWT.");
    }
    const token = jwt.sign({
        id_usuario: usuario.id_usuario,
        nombre_usuario: usuario.nombre_usuario,
        rol: usuario.rol
    }, secret, {
        expiresIn: "1d"
    });
    const { password_hash, ...datosUsuario } = usuario;
    return {
        token,
        usuario: datosUsuario
    };
};
exports.iniciarSesion = iniciarSesion;
