"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express = require("express");
const router = express.Router();
// Obtener todos los pedidos
router.get("/", (req, res) => {
    res.json({
        mensaje: "Ruta de pedidos funcionando"
    });
});
exports.default = router;
