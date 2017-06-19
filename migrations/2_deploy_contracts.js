var MTTPToken = artifacts.require("./MTTPToken.sol")
module.exports = function(deployer) {
  deployer.deploy(MTTPToken);
};