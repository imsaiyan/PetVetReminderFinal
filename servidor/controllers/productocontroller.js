const Product = require("../models/productos");

exports.CrearProducto = async (req, res) => {
  try {
    let producto;
    producto = new Product(req.body);
    await producto.save();
    res.send(producto);
  } catch (error) {
    console.log(error.message);
    res.status(200).send("hubo un error");
  }
};

exports.ObtenerProducto = async (req, res) => {
  try {
    const productos = await Product.find();
    res.json(productos);
  } catch (error) {
    console.log(error.message);
    res.status(500).send("Hubo un error al obtener los productos");
  }
};
exports.BuscarPorNombre = async (req, res) => {
  try {
    const { nombre } = req.params;
    const productos = await Product.find({ nombre: new RegExp(nombre, "i") });

    if (productos.length === 0) {
      return res.status(404).json({ mensaje: "No se encontraron productos con ese nombre" });
    }

    res.json(productos);
  } catch (error) {
    console.log(error.message);
    res.status(500).send("Hubo un error al buscar el producto");
  }
};

exports.Actualizar = async (req, res) => {
  try {
    const { nombre, categoria, ubicacion, cantidad } = req.body;

    // Buscar el producto por su ID
    let producto = await Product.findById(req.params.id);

    // Verificar si el producto existe
    if (!producto) {
      return res.status(404).json({ mensaje: "El producto no existe" });
    }

    // Actualizar los campos del producto
    producto.nombre = nombre;
    producto.categoria = categoria;
    producto.ubicacion = ubicacion;
    producto.cantidad = cantidad;

    // Actualizar el producto en la base de datos
    producto = await Product.findOneAndUpdate(
      { _id: req.params.id },
      producto,
      { new: true }
    );

    res.json(producto); // Devolver el producto actualizado
  } catch (error) {
    console.log(error.message);
    res.status(500).send("Hubo un error al actualizar el producto");
  }
};

exports.ObtenerProductos = async (req, res) => {
  try {
    let producto = await Product.findById(req.params.id);

    // Verificar si el producto existe
    if (!producto) {
      return res.status(404).json({ mensaje: "El producto no existe" });
    }

    res.json(producto); // Devolver el producto actualizado
  } catch (error) {
    console.log(error.message);
    res.status(500).send("Hubo un error al actualizar el producto");
  }
};


exports.EliminarProductos = async (req, res) => {
  try {
    let producto = await Product.findById(req.params.id);

    // Verificar si el producto existe
    if (!producto) {
      return res.status(404).json({ mensaje: "El producto no existe" });
    }

    await Product.findByIdAndDelete(req.params.id);

    res.json({ mensaje: "Producto eliminado con éxito" });
  } catch (error) {
    console.log(error.message);
    res.status(500).send("Hubo un error al eliminar el producto");
  }
};

