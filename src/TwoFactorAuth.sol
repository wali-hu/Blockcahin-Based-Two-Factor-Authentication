// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract TwoFactorAuth {
    // Custom errors for more efficient error handling
    error UserNotRegistered(address user);
    error UserAlreadyRegistered(address user);
    error InvalidOTP();
    error TimeLimitExceeded();

    // Struct to store user details
    struct User {
        string username;
        address publicKey;
        uint256 seed;
    }

    // Struct to store OTP data with time limit
    struct OTPData {
        uint256 timeLimit;
        uint256 otp;
    }

    // Mapping to store users by their public key
    mapping(address => User) public users;
    // Mapping to store OTP data by user's public key
    mapping(address => OTPData) public OTPDataOf;

    // Event to emit when a user is registered
    event UserRegistered(string username, address indexed publicKey);

    // Function to register a new user
    function registerUser(string memory _username, uint256 _seed) public {
        // Check if the user is already registered
        if (users[msg.sender].publicKey != address(0)) {
            revert UserAlreadyRegistered(msg.sender);
        }

        // Store the user's information
        users[msg.sender] = User({
            username: _username,
            publicKey: msg.sender,
            seed: _seed
        });

        // Generate an initial OTP for the user
        uint256 _otp = _generateOTP(_seed);

        // Store the OTP and its time limit
        OTPDataOf[msg.sender] = OTPData({
            timeLimit: block.timestamp + 30, // 30 seconds time limit
            otp: _otp
        });

        // Emit an event indicating successful registration
        emit UserRegistered(_username, msg.sender);
    }

    // Internal function to generate an OTP using the seed and current timestamp
    function _generateOTP(uint256 _seed) internal view returns (uint256) {
        // Generate a pseudo-random OTP by hashing the seed and timestamp
        uint256 _otp = uint256(
            keccak256(abi.encodePacked(_seed, block.timestamp))
        );
        return _otp;
    }

    // Function to generate a new OTP for the caller
    function generateOTP() public returns (uint256) {
        // Retrieve the user's information
        User memory user = users[msg.sender];
        // Check if the user is registered
        if (user.publicKey == address(0)) {
            revert UserNotRegistered(msg.sender);
        }

        // Generate a new OTP
        uint256 _otp = _generateOTP(user.seed);

        // Store the new OTP and its time limit
        OTPDataOf[msg.sender] = OTPData({
            timeLimit: block.timestamp + 30, // 30 seconds time limit
            otp: _otp
        });

        return _otp;
    }

    // Function to authenticate a user using their public key and OTP
    function authenticate(
        address _publicKey,
        uint256 _otp
    ) public view returns (bool authenticated) {
        // Retrieve the user's information
        User memory user = users[_publicKey];
        // Check if the user is registered
        if (user.publicKey == address(0)) {
            revert UserNotRegistered(_publicKey);
        }

        // Retrieve the stored OTP data for the user
        OTPData memory _userOTP = OTPDataOf[_publicKey];

        // Check if the provided OTP matches the stored OTP
        if (_userOTP.otp != _otp) {
            revert InvalidOTP();
        }
        // Check if the OTP is still within the valid time limit
        if (block.timestamp > _userOTP.timeLimit) {
            revert TimeLimitExceeded();
        }

        // If all checks pass, authentication is successful
        authenticated = true;
    }
}
