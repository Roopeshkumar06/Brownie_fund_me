//SPDX-License-Identifier:MIT
pragma solidity 0.8.13;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
// interface AggregatorV3Interface {
//   function decimals() external view returns (uint8);

//   function description() external view returns (string memory);

//   function version() external view returns (uint256);

//   // getRoundData and latestRoundData should both raise "No data present"
//   // if they do not have data to report, instead of returning unset values
//   // which could be misinterpreted as actual reported values.
//   function getRoundData(uint80 _roundId)
//     external
//     view
//     returns (
//       uint80 roundId,
//       int256 answer,
//       uint256 startedAt,
//       uint256 updatedAt,
//       uint80 answeredInRound
//     );

//   function latestRoundData()
//     external
//     view
//     returns (
//       uint80 roundId,
//       int256 answer,
//       uint256 startedAt,
//       uint256 updatedAt, 
//       uint80 answeredInRound
//     );
// }



contract FundMe{

    mapping (address=>uint) public addressToAmountFunded;
    address public owner;
    address [] public funders;
    AggregatorV3Interface public priceFeed;
    constructor(address _priceFeed){
      priceFeed=AggregatorV3Interface(_priceFeed);
      owner=msg.sender;
    }
    function fund() public  payable{
        //50$
        uint minimumInUsd=50*10**18;
        require(getConversionRate(msg.value)>=minimumInUsd,"need to spend more ether");
        addressToAmountFunded[msg.sender]+=msg.value;
        funders.push(msg.sender);
        //what the eth to USD conversion rate
    }
   
    function getVersion() public view returns (uint){
        // AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return  priceFeed.version();
    }
    function getPrice() public view returns (uint){
      // AggregatorV3Interface priceFeed=AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
      (   ,int256 answer,,,)=priceFeed.latestRoundData();
        return uint(answer *10000000000);
    }
    function getConversionRate(uint ethAmount)  public view returns(uint){
       uint ethPrice=getPrice();
       uint ethAmountInUsd =(ethAmount*ethPrice)/1000000000000000000;
       return ethAmountInUsd;
    }
    function getEntranceFee() public view returns (uint){
       //minimumUSD
       uint minimumUSD = 50* 10 **18;
       uint price = getPrice();
       uint precision = 1* 10**18;
       return (minimumUSD *precision)/price;
    }
    modifier onlyOwner{
      require(msg.sender==owner);
      _;
    }
    function withdraw()payable onlyOwner public {
      payable(msg.sender).transfer(address(this).balance);
      for(uint funderIndex=0;funderIndex<funders.length;funderIndex++){
        address funder = funders[funderIndex];
        addressToAmountFunded[funder]=0;
      }
      funders=new address[](0);
    }
      
      

} 