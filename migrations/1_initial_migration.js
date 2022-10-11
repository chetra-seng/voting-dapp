const Migrations = artifacts.require("Vote");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
