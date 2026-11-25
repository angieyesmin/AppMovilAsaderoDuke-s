import express = require("express");

const router = express.Router();

// Obtener todas las categorías
router.get("/", (req, res) => {
    res.json({
        mensaje: "Ruta de categorías funcionando"
    });
});

export default router;