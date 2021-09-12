pragma solidity ^0.8.0;

// SPDX-License-Identifier: MIT
contract raffle {

    

    struct People {
        string name;
    }

    People[] public people;

    uint modulus = 7;
    
    uint[3] level = [1, 2, 3];


    mapping (uint => string) public levelToName;
    mapping (uint => address) public countToPeople;//计的数对应的每个人的地址
    mapping (address => string) public addressToName;//地址对应人名

    uint count = 0;
    uint nonce = 0;
    address[7] prizeWinnerAddress;
    uint[7] winnerNumber;
    uint[7] countString;
    string[7] nameString;

    event upload(uint x);
    function rigister(string memory _name) public payable {
        if (msg.value > 0.01 ether) {
            address payable addr = payable(msg.sender);
            addr.transfer(msg.value - 0.01 ether);
        }
        people.push(People(_name));
        count = people.length - 1;//输入每个人的名字开始计数
        for(uint i = 1; i < count + 1; i++) {
            countString[i] = count;
        }
        countToPeople[count] = msg.sender;//操作人输入名字后，记录地址
        addressToName[msg.sender] = people[count].name;
        count++;//计数增加
        emit upload(count);
        if (count > 5) {
            _producePrize();//满1000人开奖
            emit upload(2021);
        }
    } //产生一等奖

    function _producePrize() public {
        _winnerNumber();//先启用生成获奖号码函数
        for (uint i = 0; i < 6; i++) {
            prizeWinnerAddress[i] = countToPeople[winnerNumber[i]];
        }//获奖用户地址；
        _produceFirstPrize();//返回一等奖人名及地址
        _produceSecondPrize();//二等奖人名及地址
        _produceThirdPrize();//三等奖人名及地址
        //触发事件
    }

    function _winnerNumber() public returns (uint[7] memory){//生成1000人里面获奖数字
        for (uint i = 0; i < 6; i++) {
            winnerNumber[i] = uint(keccak256(abi.encodePacked(block.timestamp+3*i, msg.sender, nonce))) % modulus;
            nonce++;
        }
        return winnerNumber;
    }

    function _produceSecondPrize() public view returns(address, address) {//二等奖的人及地址
        address[2] memory secondPrizeAddress;
        secondPrizeAddress[0] = prizeWinnerAddress[1];
        secondPrizeAddress[1] = prizeWinnerAddress[2];
        return (secondPrizeAddress[0], secondPrizeAddress[1]);
    }

    function _produceThirdPrize() public view returns(address, address, address) {//三等奖的人及地址
        address[3] memory thirdPrizeAddress;
            thirdPrizeAddress[0] = prizeWinnerAddress[3];
            thirdPrizeAddress[1] = prizeWinnerAddress[4];
            thirdPrizeAddress[2] = prizeWinnerAddress[5];
            return (thirdPrizeAddress[0], thirdPrizeAddress[1], thirdPrizeAddress[2]);
    }

    function _produceFirstPrize() public view returns(address) {//一等奖的人及地址
        address[1] memory firstPrizeAddress;
            firstPrizeAddress[0] = prizeWinnerAddress[0];
            return (firstPrizeAddress[0]);
    }



}