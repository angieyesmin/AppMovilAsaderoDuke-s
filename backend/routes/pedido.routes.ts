import express = require("express");

const router = express.Router();

// Obtener todos los pedidos
router.get("/", (req, res) => {
    res.json({
        mensaje: "Ruta de pedidos funcionando"
    });
});

export default router;