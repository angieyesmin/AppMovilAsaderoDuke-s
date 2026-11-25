"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.login = exports.registro = void 0;
const auth_service_1 = require("../services/auth.service");
// ==========================================
// REGISTRO
// ==========================================
const registro = async (req, res) => {
    try {
        const { nombreCompleto, nombreUsuario, correo, password, telefono } = req.body;
        if (!nombreCompleto ||
            !nombreUsuario ||
            !correo ||
            !password) {
            return res.status(400).json({
                mensaje: "Todos los campos obligatorios deben completarse."
            });
        }
        if (typeof password !== "string" || password.length < 8) {
            return res.status(400).json({
                mensaje: "La contraseña debe tener al menos 8 caracteres."
            });
        }
        const usuario = await (0, auth_service_1.registrarUsuario)(nombreCompleto, nombreUsuario, correo, password, telefono);
        return res.status(201).json({
            mensaje: "Usuario registrado correctamente.",
            usuario
        });
    }
    catch (error) {
        return res.status(400).json({
            mensaje: error.message || "Error al registrar usuario."
        });
    }
};
exports.registro = registro;
// ==========================================
// LOGIN
// ==========================================
const login = async (req, res) => {
    try {
        const { identificador, correo, password } = req.body;
        const usuarioLogin = identificador || correo;
        if (!usuarioLogin || !password) {
            return res.status(400).json({
                mensaje: "Ingresa tu correo o usuario y contraseña."
            });
        }
        const resultado = await (0, auth_service_1.iniciarSesion)(usuarioLogin, password);
        return res.status(200).json({
            mensaje: "Inicio de sesión exitoso.",
            ...resultado
        });
    }
    catch (error) {
        return res.status(401).json({
            mensaje: error.message || "Error al iniciar sesión."
        });
    }
};
exports.login = login;
