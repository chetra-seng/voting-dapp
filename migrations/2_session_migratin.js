const Session = artifacts.require("Session");

module.exports = function (deployer) {
  deployer.deploy(Session);
};