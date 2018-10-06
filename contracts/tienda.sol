pragma solidity ^0.4.0;

import "./Pausable.sol";
import "./main.sol";    // Importar valores de materiales por ejemplo

contract Tienda is Pausable{
    string public Name;
    CryptoReciclaje CR_main;
    
    // Cantidad de materiales que la tiena acumula
    uint128 t_papel;      // 0
    uint128 t_carton;     // 1
    uint128 t_lata;       // 2
    uint128 t_pet;        // 3

    // Crear mapa de promociones
    mapping (uint128=>uint256) public promociones;  // Numero especifica tipo de promo, uint128 la cantidad de puntos a quemar

    // Guarda la información del canje de los usuarios
    mapping (address =>mapping (uint128=>uint128)) public mis_promos;   // Usuario : Tipo de promo : Cantidad de canjeos


    constructor(string name, address admin, address main_address) public {
        Name = name;    // Nombre de la tienda
        owner = admin;  // Se setea en contruccion el admin de la tienda {Heredación deade Pausable.sol}
        CR_main = CryptoReciclaje(main_address); // Dirección del contrato creador
    }

    function sumarPuntos(address cliente, uint8 material, uint128 cantidad) onlyOwner public {
        assert(cliente > 0 && material >= 0 && material < 4 && cantidad > 0);
        uint256 points;
        if (material == 0){
            points = CR_main.precio_papel() * cantidad;
            t_papel += cantidad;
        }else if (material == 1){
            points = CR_main.precio_carton() * cantidad;
            t_carton += cantidad;
        }else if (material == 2){
            points = CR_main.precio_lata() * cantidad;
            t_lata += cantidad;
        }else if (material == 3){
            points = CR_main.precio_pet() * cantidad;
            t_pet += cantidad;
        }
        
        CR_main.sumarPuntos(cliente, points);   // Llamar a función en main para sumar puntos
    }


    // Anade una promo al mapa de promociones
    function crearPromocion(uint128 num_promo, uint256 puntos_que_vale) public onlyOwner{
        require(promociones[num_promo] == 0, "Se debe ocupar un indice sin promocion");
        promociones[num_promo] = puntos_que_vale;
    }

    // Debe eliminar una promocion del mapa
    function eliminarPromocion(uint128 num_promo) public onlyOwner{
        require(promociones[num_promo] != 0, "La promoción a eliminar debe existir");
        promociones[num_promo] = 0;  
    }

    // El cliente ejecuta esta funcion y se registra la tx ID
    function adquirirPromocion(uint128 tipo_promo) public{
        address cobrador = msg.sender;
        // Puntos del cobrador >= Puntos de la promo
        assert(CR_main.checkPuntos(cobrador) >= promociones[tipo_promo]);
        CR_main.quemarPuntos(cobrador, promociones[tipo_promo]);    // Quemar puntos
        mis_promos[cobrador][tipo_promo] += 1;  // Sumar promo
    }

    // La tienda cobra ejecutando esta funcion, verifica que usuario tenga promo
    function canjearPromocion(address cliente, uint128 tipo_promo) public onlyOwner{
        require(mis_promos[cliente][tipo_promo] > 0, "El cliente no tiene canjeada tal promoción");
        mis_promos[cliente][tipo_promo] -= 1;
    }

}
