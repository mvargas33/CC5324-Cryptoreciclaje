pragma solidity ^0.4.0;

import "./Pausable.sol";
import "./tienda.sol";   // Contratos tipo tienda para poder crearlos

contract CryptoReciclaje is Pausable{

    uint128 public precio_papel = 100;    // Precios del mercado de los materiales a reciclar
    uint128 public precio_carton = 200;
    uint128 public precio_lata = 600;
    uint128 public precio_pet = 300;

    mapping (address=>uint256) public puntos;   //  CriptoPuntos

    mapping (address=>bool) public tiendas;     // Creacion de tiendas

    constructor() public {
	// Quien inicia el contrato es el owner
    }

    modifier onlyTienda() {
	    require(tiendas[msg.sender]);
	    _;
    }

    function sumarPuntos(address cliente, uint256 points) onlyTienda public {
        puntos[cliente] += points;
    }

    function quemarPuntos(address cliente, uint256 points) public {
        puntos[cliente] -= points;
    }

    // Debe agregar una tienda al map 'tiendas'
    function crearTienda(string name, address admin) onlyOwner public returns(address nuevaTienda){
        nuevaTienda = new Tienda(name, admin, this);
        tiendas[nuevaTienda] = true;
	    return nuevaTienda;
    }
    
    function checkNameTienda(address direccion) public returns (string nombre){
        //assert(direccion >= 0);    // Indice debe ser positivo
        Tienda aux = Tienda(direccion);
        return aux.Name();
    }

    function checkPuntos(address direccion) public returns (uint256){
        return puntos[direccion];
    }

    // Debe eliminar una tienda al map 'tiendas' marcando el lugar como falso
    function eliminarTienda(address direccion) public onlyOwner {
        tiendas[direccion] = false;
    }
    

    // Cambia los precios de los materiales => Cambia asignación de puntos por materiales de forma global
    function cambiarPrecios(uint128 papel, uint128 carton, uint128 lata, uint128 pet) public onlyOwner {
        precio_papel = papel;
        precio_carton = carton;
        precio_lata = lata;
        precio_pet = pet;
    }

}
