import express = require("express");

const router = express.Router();

// Obtener todos los productos
router.get("/", (req, res) => {
    res.json({
        mensaje: "Ruta de productos funcionando"
    });
});

export default router;