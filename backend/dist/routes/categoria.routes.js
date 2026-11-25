"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express = require("express");
const router = express.Router();
// Obtener todas las categorías
router.get("/", (req, res) => {
    res.json({
        mensaje: "Ruta de categorías funcionando"
    });
});
exports.default = router;
