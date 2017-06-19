var MTTPToken = artifacts.require("./zeppelin/token/MTTPToken.sol")
module.exports = function(deployer) {
  deployer.deploy(MTTPToken);
};