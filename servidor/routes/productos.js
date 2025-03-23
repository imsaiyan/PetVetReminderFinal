const express=require('express');

const router=express.Router();

const productoController=require("../controllers/productocontroller");


router.post('/',productoController.CrearProducto);
router.get('/',productoController.ObtenerProducto);
router.put('/:id',productoController.Actualizar);
router.get('/:id',productoController.ObtenerProductos);
router.delete('/:id',productoController.EliminarProductos);
router.get('/nombre/:nombre', productoController.BuscarPorNombre);





module.exports=router;