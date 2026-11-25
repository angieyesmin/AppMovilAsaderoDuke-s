"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express = require("express");
const auth_controller_1 = require("../controllers/auth.controller");
const router = express.Router();
// Registrar usuario
router.post("/registro", auth_controller_1.registro);
// Iniciar sesión
router.post("/login", auth_controller_1.login);
exports.default = router;
