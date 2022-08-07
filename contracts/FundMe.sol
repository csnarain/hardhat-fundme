// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import './PriceConverter.sol';
import 'hardhat/console.sol';
// Error codes
    error FundMe__NotOwner();
error FundMe__Need_More_ETH();

/** @title A contract for crowd funding
* @author Laks
* @notice this contract is to demo a sample crowd funding contract
* @dev This implements price feeds as our library
*/

contract FundMe {
    using PriceConverter for uint;
    uint public constant MINIMUM_USD = 10;
    uint testVar;
    // State Variables
    mapping(address => uint) private s_addressToAmountFunded;
    address[] private s_funders;
    address private immutable i_owner;
    uint public priceInUsd;
    AggregatorV3Interface private s_priceFeed;

    modifier onlyOwner() {
        if (msg.sender != i_owner)
            revert FundMe__NotOwner();
        // require(msg.sender == i_owner);
        _;
    }

    constructor (address priceFeedAddress) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeedAddress);
    }
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    /**
    * @notice this contract is to demo a sample crowd funding contract
* @dev This implements price feeds as our library
*/

    function fund() public payable {
        if(msg.value.getConversionRate(s_priceFeed)/1e18 < MINIMUM_USD)
            revert FundMe__Need_More_ETH();
//        require(msg.value.getConversionRate(s_priceFeed) / 1e18 >= MINIMUM_USD, "You need to spend more ETH!");
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function withdraw() public onlyOwner {
        for (uint funderIndex = 0; funderIndex < s_funders.length; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        // reset funders Array
        s_funders = new address[](0);
        // withdraw funds
        //        payable(msg.sender.transfer(address(this).balance));
        //        bool success = payable(msg.sender.send(address(this).balance));
        //        require(success, 'Send failed');
        (bool callSuccess,) = payable(msg.sender).call{value : address(this).balance}('');
        require(callSuccess, 'call failed');
    }

    function cheap_withdraw() public onlyOwner {
        address [] memory funders = s_funders;
        //        _addressToAmountFunded = s_addressToAmountFunded;
        for (uint funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;

        }
        s_funders = new address[](0);
        (bool success,) = i_owner.call{value : address(this).balance}('');
        //        (bool callSuccess,) = payable(msg.sender).call(value : address(this).balance}(''));
        require(success, 'call failed');
    }

    function getOwner() public view returns (address){
        return i_owner;
    }

    function getFunder(uint index) public view returns (address) {
        return s_funders[index];
    }

    function getAddressToAmountFunded(address funder) public view returns (uint) {
        return s_addressToAmountFunded[funder];
    }

    function getPriceFeed() public view returns (AggregatorV3Interface){
        return s_priceFeed;
    }
}