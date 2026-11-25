import express = require("express");

const router = express.Router();

// Obtener todos los usuarios
router.get("/", (req, res) => {
    res.json({
        mensaje: "Ruta de usuarios funcionando"
    });
});

export default router;