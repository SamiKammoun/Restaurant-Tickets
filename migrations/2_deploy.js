const Restaurant = artifacts.require('Restaurant.sol');

module.exports = function (deployer){
    deployer.deploy(Restaurant);
}