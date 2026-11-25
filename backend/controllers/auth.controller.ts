import { Request, Response } from "express";
import jwt = require("jsonwebtoken");

import {
    registrarUsuario,
    iniciarSesion,
    obtenerPerfil
} from "../services/auth.service";

// ==========================================
// REGISTRAR USUARIO
// ==========================================

export const registro = async (
    req: Request,
    res: Response
) => {

    try {

        const {
            nombreCompleto,
            nombreUsuario,
            correo,
            password,
            telefono
        } = req.body;

        if (
            ![nombreCompleto, nombreUsuario, correo, password]
                .every(v => typeof v === "string" && v.trim())
        ) {
            return res.status(400).json({
                mensaje: "Completa los campos obligatorios."
            });
        }

        if (password.length < 8) {
            return res.status(400).json({
                mensaje: "La contraseña debe tener al menos 8 caracteres."
            });
        }

        const usuario = await registrarUsuario(
            nombreCompleto,
            nombreUsuario,
            correo,
            password,
            telefono
        );

        return res.status(201).json({
            mensaje: "Usuario registrado correctamente.",
            usuario
        });

    } catch (error: unknown) {

        const mensaje = error instanceof Error
            ? error.message
            : "Error al registrar usuario.";

        console.error("ERROR EN REGISTRO:", mensaje);

        return res.status(400).json({
            mensaje
        });
    }
};

// ==========================================
// INICIAR SESIÓN
// ==========================================

export const login = async (
    req: Request,
    res: Response
) => {

    try {

        const {
            identificador,
            correo,
            password
        } = req.body;

        const usuarioLogin = identificador || correo;

        if (
            typeof usuarioLogin !== "string" ||
            !usuarioLogin.trim() ||
            typeof password !== "string" ||
            !password
        ) {
            return res.status(400).json({
                mensaje: "Ingresa tu correo o usuario y contraseña."
            });
        }

        const resultado = await iniciarSesion(
            usuarioLogin,
            password
        );

        return res.status(200).json({
            mensaje: "Inicio de sesión exitoso.",
            ...resultado
        });

    } catch (error: unknown) {

        return res.status(401).json({
            mensaje: error instanceof Error
                ? error.message
                : "Error al iniciar sesión."
        });
    }
};

// ==========================================
// OBTENER PERFIL
// ==========================================

export const perfil = async (
    req: Request,
    res: Response
) => {

    const autorizacion = req.headers.authorization;

    if (!autorizacion?.startsWith("Bearer ")) {
        return res.status(401).json({
            mensaje: "Debes iniciar sesión."
        });
    }

    const token = autorizacion.substring(7);
    const secret = process.env.JWT_SECRET;

    if (!secret) {
        return res.status(500).json({
            mensaje: "Error de configuración del servidor."
        });
    }

    let idUsuario: number;

    try {

        const datos = jwt.verify(token, secret, {
            algorithms: ["HS256"]
        });

        if (
            typeof datos === "string" ||
            !Number.isInteger(datos.id_usuario)
        ) {
            return res.status(401).json({
                mensaje: "Token inválido."
            });
        }

        idUsuario = datos.id_usuario;

    } catch {

        return res.status(401).json({
            mensaje: "Tu sesión ha expirado o no es válida."
        });
    }

    try {

        const usuario = await obtenerPerfil(idUsuario);

        if (!usuario) {
            return res.status(401).json({
                mensaje: "Usuario no encontrado o inactivo."
            });
        }

        return res.status(200).json({
            mensaje: "Perfil obtenido correctamente.",
            usuario
        });

    } catch (error) {

        console.error("ERROR AL CONSULTAR PERFIL:", error);

        return res.status(500).json({
            mensaje: "No se pudo obtener el perfil."
        });
    }
};