import express = require("express");

import {
    registro,
    login,
    perfil
} from "../controllers/auth.controller";

const router = express.Router();

// ==========================================
// RUTAS DE AUTENTICACIÓN
// ==========================================

// Registrar usuario
router.post("/registro", registro);

// Iniciar sesión
router.post("/login", login);

// Consultar perfil del usuario
router.get("/perfil", perfil);

export default router;