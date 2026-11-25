"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express = require("express");
const router = express.Router();
// Obtener todos los usuarios
router.get("/", (req, res) => {
    res.json({
        mensaje: "Ruta de usuarios funcionando"
    });
});
exports.default = router;
