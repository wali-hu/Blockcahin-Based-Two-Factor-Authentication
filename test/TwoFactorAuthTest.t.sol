// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {TwoFactorAuth} from "../src/TwoFactorAuth.sol";

contract TwoFactorAuthTest is Test {
    TwoFactorAuth private twoFactorAuth;
    address private user1;
    address private user2;

    function setUp() public {
        twoFactorAuth = new TwoFactorAuth();
        user1 = address(0x123);
        user2 = address(0x456);

        // Fund the user accounts with ETH for gas
        vm.deal(user1, 1 ether);
        vm.deal(user2, 1 ether);
    }

    function testRegisterUser() public {
        vm.startPrank(user1);
        twoFactorAuth.registerUser("User1", 12345);
        (
            string memory username,
            address publicKey,
            uint256 seed
        ) = twoFactorAuth.users(user1);
        assertEq(username, "User1");
        assertEq(publicKey, user1);
        assertEq(seed, 12345);
        vm.stopPrank();
    }

    function testGenerateOTP() public {
        vm.startPrank(user1);
        twoFactorAuth.registerUser("User1", 12345);
        uint256 otp1 = twoFactorAuth.generateOTP();
        assert(otp1 != 0); // OTP should not be zero

        // Wait for 31 seconds to ensure the OTP time limit expires
        vm.warp(block.timestamp + 31);
        uint256 otp2 = twoFactorAuth.generateOTP();
        assert(otp1 != otp2); // OTP should be different after expiry
        vm.stopPrank();
    }

    function testAuthenticate() public {
        vm.startPrank(user1);
        twoFactorAuth.registerUser("User1", 12345);
        uint256 otp = twoFactorAuth.generateOTP();

        // Authenticate with valid OTP
        bool authenticated = twoFactorAuth.authenticate(user1, otp);
        assertTrue(authenticated);

        // Wait for 31 seconds to ensure the OTP time limit expires
        vm.warp(block.timestamp + 31);

        // Authenticate with expired OTP
        vm.expectRevert(abi.encodeWithSignature("TimeLimitExceeded()"));
        twoFactorAuth.authenticate(user1, otp);
        vm.stopPrank();
    }

    function testInvalidOTP() public {
        vm.startPrank(user1);
        twoFactorAuth.registerUser("User1", 12345);
        uint256 otp = twoFactorAuth.generateOTP();

        // Authenticate with invalid OTP
        vm.expectRevert(abi.encodeWithSignature("InvalidOTP()"));
        twoFactorAuth.authenticate(user1, otp + 1);
        vm.stopPrank();
    }

    function testUserNotRegistered() public {
        vm.startPrank(user2);

        // Attempt to generate OTP for unregistered user
        vm.expectRevert(
            abi.encodeWithSignature("UserNotRegistered(address)", user2)
        );
        twoFactorAuth.generateOTP();

        // Attempt to authenticate unregistered user
        vm.expectRevert(
            abi.encodeWithSignature("UserNotRegistered(address)", user2)
        );
        twoFactorAuth.authenticate(user2, 12345);
        vm.stopPrank();
    }
}
