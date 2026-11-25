"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
require("dotenv/config");
const express = require("express");
const cors = require("cors");
const database_1 = require("./config/database");
// Rutas
const auth_routes_1 = __importDefault(require("./routes/auth.routes"));
const categoria_routes_1 = __importDefault(require("./routes/categoria.routes"));
const producto_routes_1 = __importDefault(require("./routes/producto.routes"));
const promocion_routes_1 = __importDefault(require("./routes/promocion.routes"));
const pedido_routes_1 = __importDefault(require("./routes/pedido.routes"));
const usuario_routes_1 = __importDefault(require("./routes/usuario.routes"));
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
app.use("/api/auth", auth_routes_1.default);
app.use("/api/categorias", categoria_routes_1.default);
app.use("/api/productos", producto_routes_1.default);
app.use("/api/promociones", promocion_routes_1.default);
app.use("/api/pedidos", pedido_routes_1.default);
app.use("/api/usuarios", usuario_routes_1.default);
// Puerto
const PORT = Number(process.env.PORT || 3000);
// Iniciar servidor
const iniciarServidor = async () => {
    try {
        await (0, database_1.probarConexion)();
        app.listen(PORT, "0.0.0.0", () => {
            console.log(`Servidor ejecutándose en puerto ${PORT}`);
            console.log(`http://localhost:${PORT}`);
        });
    }
    catch (error) {
        console.error("No se pudo iniciar el servidor:", error);
        process.exit(1);
    }
};
iniciarServidor();
