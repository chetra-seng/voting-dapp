const Vote = artifacts.require("Vote");
const Admin = artifacts.require("Admin");

module.exports = async (deployer) => {
  console.log("Setting admin storage");
  const admin = await Admin.deployed();
  const vote = await Vote.deployed();
  await vote.updateAdminContract(admin.address);
}