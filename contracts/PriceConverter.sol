// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import '@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol';


library PriceConverter {
    function getVersion(AggregatorV3Interface price_feed) internal view returns (uint) {
        // AggregatorV3Interface price_feed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return price_feed.version();
    }

    function getPrice(AggregatorV3Interface price_feed) internal view returns (uint) {
        // AggregatorV3Interface price_feed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int price,,,) = price_feed.latestRoundData();
        return uint(price * 1e10);
    }

    function getConversionRate(uint ethAmount, AggregatorV3Interface price_feed) internal view returns (uint) {
        uint ethPrice = getPrice(price_feed);
        uint ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}