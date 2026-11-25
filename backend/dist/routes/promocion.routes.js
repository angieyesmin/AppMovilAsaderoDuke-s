"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express = require("express");
const router = express.Router();
// Obtener todas las promociones
router.get("/", (req, res) => {
    res.json({
        mensaje: "Ruta de promociones funcionando"
    });
});
exports.default = router;
