const Admin = artifacts.require("Admin");

module.exports = function (deployer) {
  deployer.deploy(Admin);
};
