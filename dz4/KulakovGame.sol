// SPDX-License-Identifier: MIT

pragma solidity ^0.8.3;

contract KulakovGame {

    struct MemberOfGame {
        uint256 isReady;
        uint256 memberSymbol;
        bytes32 move;
        address payable memberAddress;
    }

    event Added(address member);
    event Show(address member);
    event ShowToOtherMembers(address member, uint256 memberSymbol);
    event GetReward(address member, uint amount);


    uint public valueOfGame = 0;
        MemberOfGame member1 = MemberOfGame(1, 0, 0x0, payable(address(0x0)));
        MemberOfGame member2 = MemberOfGame(1, 0, 0x0, payable(address(0x0)));

    modifier canAddPlayer() {
        require(
            (member1.memberAddress == payable(address(0x0)) ||
             member2.memberAddress == payable(address(0x0))) &&
                (member1.isReady == 1 || member2.isReady == 1) &&
                (member1.move == 0x0 || member2.move == 0x0) &&
                (member1.memberSymbol == 0 || member2.memberSymbol == 0)
                );

        _;
    }

     modifier gameReward() {

        require(msg.value > 0);

        _;
    }

    function addMember() public payable canAddPlayer gameReward returns (uint256) {
        if (member1.isReady == 1) {

            if (member2.isReady == 1){
                valueOfGame = msg.value;

            } else {
                require(valueOfGame == msg.value, "invalid value");
            }
            member1.memberAddress = payable(msg.sender);

            member1.isReady = 2;
            emit Added(msg.sender);
            return 1;
        } else if (member2.isReady == 1) {

            if (member1.isReady == 1){
                valueOfGame = msg.value;

            } else {
                require(valueOfGame == msg.value, "invalid value");
            }
            member2.memberAddress = payable(msg.sender);
            member2.isReady = 2;



            emit Added(msg.sender);
            return 2;
        }

        return 0;
    }

    modifier canShow() {
        require((member1.memberAddress != payable(address(0x0))
        && member2.memberAddress != payable(address(0x0))) &&
                (member1.memberSymbol == 0 && member2.memberSymbol == 0) &&
                (member1.move == 0x0
                || member2.move == 0x0) &&
                (member1.isReady == 2
                 || member2.isReady == 2));
        _;
    }

    modifier isMember() {
        require (msg.sender == member1.memberAddress || msg.sender == member2.memberAddress);

        _;
    }

    function startShowing(bytes32 move) public canShow isMember returns (bool) {
        if (msg.sender == member1.memberAddress && member1.move == 0x0) {
            member1.move = move;
            member1.isReady = 3;
        } else if (msg.sender == member2.memberAddress && member2.move == 0x0) {
            member2.move = move;
            member2.isReady = 3;
        } else {
            return false;
        }
        emit Show(msg.sender);
        return true;
    }

    modifier areAllReady() {
        require((member1.memberSymbol == 0 || member2.memberSymbol == 0) &&
                (member1.move != 0x0 && member2.move != 0x0) &&
                (member1.isReady == 3 || member2.isReady == 3));
        _;
    }

    function getingResults(uint256 memberSymbol, string calldata pad) public areAllReady isMember returns (bool) {
        if (msg.sender == member1.memberAddress) {
            require(sha256(abi.encodePacked(msg.sender, memberSymbol, pad)) == member1.move, "exception");


            member1.memberSymbol = memberSymbol;
            member1.isReady = 4;

            emit ShowToOtherMembers(msg.sender, memberSymbol);
            return true;
        } else if (msg.sender == member2.memberAddress){
            require(sha256(abi.encodePacked(msg.sender, memberSymbol, pad)) == member2.move, "exception");
            member2.memberSymbol = memberSymbol;

            member2.isReady = 4;

            emit ShowToOtherMembers(msg.sender, memberSymbol);
            return true;
        }
        return false;
    }


    modifier canGetReward() {
        require((member1.memberSymbol != 0 && member2.memberSymbol != 0)
                &&
                (member1.move != 0x0 && member2.move != 0x0)
                &&
                (member1.isReady == 4 && member2.isReady == 4));
        _;
    }


     function endRound() public canGetReward isMember returns (uint) {
        if (member1.memberSymbol == member2.memberSymbol) {
            address payable firstAddress = member1.memberAddress;

            address payable secondAddress = member1.memberAddress;

            uint amount = valueOfGame;
            finishTheGame();
            firstAddress.transfer(amount);
            secondAddress.transfer(amount);

            emit GetReward(firstAddress, amount);
            emit GetReward(secondAddress, amount);
            return 0;
        } else if ((
            member1.memberSymbol == 1 && member2.memberSymbol == 3) ||
                   (member1.memberSymbol == 2 && member2.memberSymbol == 1)     ||
                   (member1.memberSymbol == 3 && member2.memberSymbol == 2)) {
            address payable addressToReward = member1.memberAddress;
            uint amount = 2 * valueOfGame;

            finishTheGame();

            addressToReward.transfer(amount);
            emit GetReward(addressToReward, amount);
            return 1;
        } else {
            address payable addressToReward = member2.memberAddress;

            uint amount = 2 * valueOfGame;
            finishTheGame();
            addressToReward.transfer(amount);
            emit GetReward(addressToReward, amount);
            return 2;
        }
    }

    function finishTheGame() private {
        member1 = MemberOfGame(1, 0, 0x0, payable(address(0x0)));
        member2 = MemberOfGame(1, 0, 0x0, payable(address(0x0)));

        valueOfGame = 0;
    }

}