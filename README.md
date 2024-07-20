# TwoFactorAuth Smart Contract

This project implements a blockchain-based Two-Factor Authentication (2FA) system using a smart contract deployed on the Ethereum blockchain. It enhances user authentication security by combining blockchain technology with One-Time Passwords (OTPs).

## Overview

The `TwoFactorAuth` smart contract provides functionalities for user registration, OTP generation, and user authentication. It leverages custom error handling to manage various error states effectively.



### Usage

1. **Deploy the Contract**: Run the deployment script to deploy the contract to your desired network.
2. **Interact with the Contract**: Use the JavaScript interaction script to register users, generate OTPs, and authenticate users.


## Installation and Setup

1. **Clone the repository**:
    ```bash
    git clone [<repository-url>](https://https://github.com/wali-hu/Blockcahin-Based-Two-Factor-Authentication)
    cd Blockcahin-Based-Two-Factor-Authentication
    ```

2. **Install dependencies**:
    ```bash
    npm install
    ```

3. **Compile the smart contract**:
    ```bash
    forge build
    ```

4. **Deploy And Test the contract**:
    ```bash
    forge script DeployTwoFactorAuth.s.sol
    ```
    ```bash
    forge test
    ```

5. **Run the interaction script**:
    ```bash
    node interact.js
    ```

## License

This project is licensed under the MIT License.

## Acknowledgements

- **Forge**: For smart contract development and testing.
- **Ethers.js**: For interacting with Ethereum from JavaScript.
