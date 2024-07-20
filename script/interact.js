require('dotenv').config();
const { ethers } = require("ethers");

const provider = new ethers.providers.JsonRpcProvider("http://localhost:8545");
const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

const abi = [
    "function registerUser(string memory _username, uint256 _seed) public",
    "function generateOTP() public returns (uint256)",
    "function authenticate(address _publicKey, uint256 _otp) public view returns (bool)"
];

const contractAddress = "your_deployed_contract_address_here";
const contract = new ethers.Contract(contractAddress, abi, wallet);

async function main() {
    // Example: Register a user
    let tx = await contract.registerUser("User1", 12345);
    await tx.wait();
    console.log("User registered");

    // Example: Generate OTP
    let otp = await contract.generateOTP();
    console.log(`Generated OTP: ${otp.toString()}`);

    // Example: Authenticate User
    let isAuthenticated = await contract.authenticate(wallet.address, otp);
    console.log(`Is authenticated: ${isAuthenticated}`);
}

main().catch(console.error);
