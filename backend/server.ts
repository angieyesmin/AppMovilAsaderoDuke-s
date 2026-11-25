import "dotenv/config";
import express = require("express");
import cors = require("cors");

import { probarConexion } from "./config/database";

// Rutas
import authRoutes from "./routes/auth.routes";
import categoriaRoutes from "./routes/categoria.routes";
import productoRoutes from "./routes/producto.routes";
import promocionRoutes from "./routes/promocion.routes";
import pedidoRoutes from "./routes/pedido.routes";
import usuarioRoutes from "./routes/usuario.routes";

const app = express();

// Middlewares
app.use(cors());
app.use(express.json());

// Ruta principal
app.get("/", (req, res) => {
    res.json({
        mensaje: "API Asadero Duke's funcionando correctamente",
        estado: "Conectado"
    });
});

// Rutas API
app.use("/api/auth", authRoutes);
app.use("/api/categorias", categoriaRoutes);
app.use("/api/productos", productoRoutes);
app.use("/api/promociones", promocionRoutes);
app.use("/api/pedidos", pedidoRoutes);
app.use("/api/usuarios", usuarioRoutes);

// Puerto
const PORT = Number(process.env.PORT || 3000);

// Iniciar servidor
const iniciarServidor = async () => {
    try {
        await probarConexion();

        app.listen(PORT, "0.0.0.0", () => {
            console.log(`Servidor ejecutándose en puerto ${PORT}`);
            console.log(`http://localhost:${PORT}`);
        });

    } catch (error) {
        console.error("No se pudo iniciar el servidor:", error);
        process.exit(1);
    }
};

iniciarServidor();