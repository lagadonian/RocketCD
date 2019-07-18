var Rocket = artifacts.require("./Rocket.sol");

module.exports = function(deployer) {
  deployer.deploy(Rocket);
};
